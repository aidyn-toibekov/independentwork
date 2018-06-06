package independentwork.main.model.auth;

import jandcode.auth.*;
import jandcode.auth.impl.*;
import jandcode.dbm.data.*;
import jandcode.dbm.dblang.*;
import jandcode.lang.*;
import jandcode.utils.*;

import java.util.*;

public class RoleImplEx extends RoleImpl {

    //название роли (на всех языках)
    protected Map<String, String> langName = new HashMap<String, String>();

    //полное название роли (на всех языках)
    protected Map<String, String> langFullName = new HashMap<String, String>();

    //Сервис поддержки баз данных с мультиязыковыми данными
    DblangService dblangService;

    private HashSet<IPrivWrap> rolePrivs = new HashSet<IPrivWrap>();

    private class RolePriv implements IPrivWrap{
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

    public RoleImplEx(DblangService dblangService) {
        this.dblangService = dblangService;
    }

    /**
     * Устаналивает название роли на всех языках
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
     * Устаналивает полное название роли на всех языках
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

    public String getTitle() {
        String title = langName.get(dblangService.getCurrentLang().getName());
        if (title == "") {
            title = langName.get(dblangService.getDefaultLang().getName());
        }
        if (title == "") {
            for (String val : langName.values()) {
                if (val != null || val != "") {
                    title = val;
                    break;
                }
            }
        }
        return title;
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


    public HashSet<IPrivWrap> getRolePrivs() {
        return rolePrivs;
    }

    public HashSetNoCase getPrivNames() {
        HashSetNoCase privNames = new HashSetNoCase();
        for (IPrivWrap rolePriv : rolePrivs) {
            privNames.add(rolePriv.getPrivName());
        }
        return privNames;
    }

    public ListNamed<IPriv> getPrivs(AuthService svc) {
        ListNamed<IPriv> res = new ListNamed<IPriv>();
        for (String privName : getPrivNames()) {
            IPriv priv = svc.getPrivs().find(privName);
            if (priv != null) {
                res.add(priv);
            }
        }
        return res;
    }

    public void addRolePriv(String privName, long busProcessBefore, long busProcessAfter) {
        RolePriv rolePriv = new RolePriv();
        rolePriv.privName = privName;
        rolePriv.busProcessBefore = busProcessBefore;
        rolePriv.busProcessAfter = busProcessAfter;
        rolePrivs.add(rolePriv);
    }

    public long getBusProcess(String privName, String place) {
        for (IPrivWrap rolePriv : rolePrivs) {
            if (rolePriv.getPrivName().equals(privName)) {
                if (place.equals("before")) return rolePriv.getBusProcessBefore();
                if (place.equals("after")) return rolePriv.getBusProcessAfter();
            }
        }
        return -1;
    }
}
