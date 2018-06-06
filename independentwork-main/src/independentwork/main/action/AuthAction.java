package independentwork.main.action;

import independentwork.main.filter.*;
import jandcode.auth.*;
import jandcode.dbm.*;
import jandcode.web.*;

import java.util.*;

public class AuthAction extends WebAction {

    public void login() throws Exception {
        // текущая модель
        Model model = getApp().service(ModelService.class).getModel();
        // login
        IUserInfo ui = (IUserInfo) model.daoinvoke("AuthUser/auth", "login",
                getParams().getValueString("login"), getParams().getValueString("passwd"));
        Collection<IRole> roles = (Collection) model.daoinvoke("AuthUser/auth", "loadAllRoles");
        // инитим сессию
        getApp().service(AuthService.class).setCurrentUser(ui);
        getApp().service(AuthService.class).updateRoles(roles);
        getSession().put(AuthFilter.getUserSessionKey(getApp(), AuthFilter.USERINFO), ui);
        getRequest().getOutWriter().write("ok");
    }

    public void logout() throws Exception {
        getApp().service(AuthService.class).setCurrentUser(null);
        getSession().put(AuthFilter.getUserSessionKey(getApp(), AuthFilter.USERINFO), null);
        getRequest().getOutWriter().write("ok");
    }

}
