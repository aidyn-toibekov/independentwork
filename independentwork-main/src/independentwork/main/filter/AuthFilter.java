package independentwork.main.filter;

import independentwork.main.utils.*;
import jandcode.app.*;
import jandcode.auth.*;
import jandcode.dbm.*;
import jandcode.utils.*;
import jandcode.web.*;
import org.apache.commons.logging.*;

import java.util.*;

public class AuthFilter extends WebFilter {

    protected static Log log = LogFactory.getLog(AuthFilter.class);

    public static final String USERINFO = "USERINFO";
    public static final String AUTOLOGIN = "AUTOLOGIN";

    public static final String AUTOLOGIN_USERNAME = "auth/autologin:username";
    public static final String AUTOLOGIN_PASSWORD = "auth/autologin:password";

    public static String getUserSessionKey(App app, String name) {
        // текущее приложение
        String curapp = app.service(ExpAppService.class).getCurrentExpApp().getName();
        // текущая модель
        Model model = app.service(ModelService.class).getModel();
        return AuthFilter.class.getName() + "." + curapp + "." + model.getName() + "." + name;
    }

    protected void onBeforeExec() throws Exception {
        // забираем из сессии информацию о пользователе
        IUserInfo ui = (IUserInfo) getRequest().getSession().get(AuthFilter.getUserSessionKey(getApp(), USERINFO));
        // делаем этого пользователя текущим для запроса
        ui = getApp().service(AuthService.class).setCurrentUser(ui);
        //
        if (ui.isGuest() && getApp().isDebug()) {
            // автологин, если не залогинен и отладочный режим
            devAutoLogin();
        }
    }

    protected void devAutoLogin() throws Exception {
        String skey = AuthFilter.getUserSessionKey(getApp(), AUTOLOGIN);
        // autologin срабатывает только раз
        if (getSession().get(skey) != null) {
            return;
        }
        getSession().put(skey, true);
        //
        String un = getApp().getRt().getValueString(AUTOLOGIN_USERNAME);
        if (UtString.empty(un)) {
            return; // нет имени пользователя для autologin
        }

        String pw = getApp().getRt().getValueString(AUTOLOGIN_PASSWORD);
        //
        IUserInfo ui = null;
        try {
            log.info("autoLogin: " + un + "/" + pw);
            ui = (IUserInfo) getApp().service(ModelService.class).getModel().daoinvoke("AuthUser/auth", "login", un, pw);
        } catch (Exception e) {
            log.error("ERROR autoLogin", e);
            return; // не сработал
        }
        getApp().service(AuthService.class).setCurrentUser(ui);
        getSession().put(AuthFilter.getUserSessionKey(getApp(), USERINFO), ui);

        try {
            Collection<IRole> roles = (Collection<IRole>) getApp().service(ModelService.class).getModel().daoinvoke("AuthUser/auth", "loadAllRoles");
            getApp().service(AuthService.class).updateRoles(roles);
        } catch (Exception e) {
            log.error("ERROR autoLogin (loadAllRoles)", e);
            return; // не сработал
        }
    }

}
