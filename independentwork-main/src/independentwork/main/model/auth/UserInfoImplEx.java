package independentwork.main.model.auth;

import jandcode.auth.*;
import jandcode.auth.impl.*;
import jandcode.dbm.data.*;
import jandcode.dbm.dblang.*;
import jandcode.lang.*;
import jandcode.utils.*;

import java.util.*;

public class UserInfoImplEx extends UserInfoImpl {

    //название пользователя (на всех языках)
    protected Map<String, String> langName = new HashMap<String, String>();

    //полное название пользователя (на всех языках)
    protected Map<String, String> langFullName = new HashMap<String, String>();

    //Сервис поддержки баз данных с мультиязыковыми данными
    DblangService dblangService;

    protected LinkedHashSet<String> rolesOrd = new LinkedHashSet<String>();
    //protected HashSetNoCase userPrivs = new HashSetNoCase();

    private HashSet<IPrivWrap> userPrivs = new HashSet<IPrivWrap>();


    private class UserPriv implements IPrivWrap {
        String privName;
        long busProcessBefore;
        long busProcessAfter;

        public String getPrivName() {
            return this.privName;
        }

        public long getBusProcessBefore() {
            return this.busProcessBefore;
        }

        public long getBusProcessAfter() {
            return this.busProcessAfter;
        }

    }

    public UserInfoImplEx(AuthService authService, DblangService dblangService) {
        super(authService);
        this.dblangService = dblangService;
    }

    public boolean isSysadmin() {
        return getId() == 1;
    }

    /**
     * Устаналивает название пользователя на всех языках
     *
     * @param rec       запись из базы данных
     * @param fieldName название поля, которое хранит краткое название роли
     */
    public void setLangName(DataRecord rec, String fieldName) {
        langName.clear();

        for (Lang lang : dblangService.getLangs()) {
            langName.put(lang.getName(), rec.getValueString(fieldName + "_" + lang.getName()));
        }
    }

    /**
     * Устаналивает полное название пользователя на всех языках
     *
     * @param rec       запись из базы данных
     * @param fieldName название поля, которое хранит полное название роли
     */
    public void setLangFullName(DataRecord rec, String fieldName) {
        langFullName.clear();

        for (Lang lang : dblangService.getLangs()) {
            langFullName.put(lang.getName(), rec.getValueString(fieldName + "_" + lang.getName()));
        }
    }

    public String getShortname() {
        String shortname = langName.get(dblangService.getCurrentLang().getName());
        if (shortname == "") {
            shortname = langName.get(dblangService.getDefaultLang().getName());
        }
        if (shortname == "") {
            for (String val : langName.values()) {
                if (val != null || val != "") {
                    shortname = val;
                    break;
                }
            }
        }
        return shortname;
    }

    public String getFullname() {
        String fullname = langFullName.get(dblangService.getCurrentLang().getName());
        if (fullname == "") {
            fullname = langFullName.get(dblangService.getDefaultLang().getName());
        }
        if (fullname == "") {
            for (String val : langFullName.values()) {
                if (val != null || val != "") {
                    fullname = val;
                    break;
                }
            }
        }
        return fullname;
    }

    /**
     * Проверяет есть ли к данной цели прямой доступ.
     *
     * @return true только в том случае если к данной цели есть только прямой доступ,
     * false - в остальных случаях (доступ через бизнес правила или вообще нету доступа)
     */
    public boolean hasDirectAccess(String target) {
        return getBusProcess(target, "before") == 0 && getBusProcess(target, "after") == 0;
    }

    /**
     * Возвращает id бизнесс процесса для данной цели.
     *
     * @return id бизнес процесса,
     * или 0 в том случае если доступ прямой
     */
    public long getBusProcess(String target, String place) {
        if (isSysadmin()) {
            return 0;
        }

        if (!checkTarget(target, false)) return -1;

        for (IPrivWrap userPriv : userPrivs) {
            if (userPriv.getPrivName().equals(target)) {
                if (place.equals("before"))
                    return userPriv.getBusProcessBefore();
                if (place.equals("after"))
                    return userPriv.getBusProcessAfter();
            }
        }

        long busProcess = -1;
        for (IRole role : getRoles()) {
            busProcess = ((RoleImplEx) role).getBusProcess(target, place);
            if (busProcess > -1) return busProcess;
        }

        if (busProcess == -1)
            busProcess = 0;

        return busProcess;
    }


    public boolean checkTarget(String target, boolean generateError) {
        if (isSysadmin()) {
            return true;
        }

        if (hasPriv(target)) {
            return true;
        } else {

            if (generateError) {
                throw new XErrorAccessDenied(target);
            }

            return false;
        }
    }


    public void updateRoles(Collection<String> roleNames) {
        rolesOrd.clear();
        for (String roleName : roleNames) {
            rolesOrd.add(roleName.toLowerCase());
        }
    }

    public ListNamed<IRole> getRoles() {
        ListNamed<IRole> res = new ListNamed<IRole>();
        AuthService svc = getAuthService();
        for (String r : rolesOrd) {
            IRole rr = svc.getRoles().find(r);
            if (rr != null) {
                res.add(rr);
            }
        }
        return res;
    }

    public ListNamed<IPriv> getPrivs() {
        ListNamed<IPriv> res = new ListNamed<IPriv>();
        AuthService svc = getAuthService();
        for (IRole r : getRoles()) {
            for (String priv : r.getPrivNames()) {
                IPriv p = svc.getPrivs().find(priv);

                if (p != null) {
                    res.add(p);
                }
            }
        }

        for (String priv : getPrivNames()) {
            IPriv p = svc.getPrivs().find(priv);
            if (p != null) {
                res.add(p);
            }
        }
        return res;
    }

    public HashSetNoCase getPrivNames() {
        HashSetNoCase privNames = new HashSetNoCase();
        for (IPrivWrap userPriv : userPrivs) {
            privNames.add(userPriv.getPrivName());
        }
        return privNames;
    }

    public void addUserPriv(String privName, long busProcessBefore, long busProcessAfter) {
        UserPriv userPriv = new UserPriv();
        userPriv.privName = privName;
        userPriv.busProcessBefore = busProcessBefore;
        userPriv.busProcessAfter = busProcessAfter;
        userPrivs.add(userPriv);
    }

}
