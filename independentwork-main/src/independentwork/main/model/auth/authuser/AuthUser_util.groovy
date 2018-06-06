package independentwork.main.model.auth.authuser

import independentwork.main.model.auth.UserInfoImplEx
import jandcode.auth.*
import jandcode.dbm.dao.*
import jandcode.wax.core.model.*

/**
 * Утилиты
 */
public class AuthUser_util extends WaxDao {

    /**
     * Проверить цель.
     *
     * @param target цель. Цель - это строка вида 'NAMESPACE:OBJECTNAME',
     *                      например 'action:show/basedata'
     * @param generateError true - генерится ошибка XErrorAccessDenied,
     *                      false - возвращается false
     */
    @DaoMethod
    public boolean checkTarget(String target, boolean generateError) throws Exception {
        return app.service(AuthService).getCurrentUser().checkTarget(target, generateError)
    }

    /**
     * Проверить имеет ли к цели прямой доступ
     *
     * @param target цель. Цель - это строка вида 'NAMESPACE:OBJECTNAME',
     *                      например 'action:show/basedata'
     * @param return true если прямой доступ, false если доступ через бизнес правила
     */
    @DaoMethod
    public boolean hasDirectAccess(String target) throws Exception {
        IUserInfo io = app.service(AuthService).getCurrentUser()
        if (io instanceof UserInfoImplEx)
            return ((UserInfoImplEx) app.service(AuthService).getCurrentUser()).hasDirectAccess(target)
        else
            return false
    }

    @DaoMethod
    public Map getCredentialsInfo(String target) {
        Map res = [:]
        IUserInfo io = app.service(AuthService).getCurrentUser()
        res.put("guest", io.isGuest())
        res.put("hasAccess", io.checkTarget(target, false))
        if (io instanceof UserInfoImplEx) {
            res.put("hasDirectAccess", io.hasDirectAccess(target))
        }
        return res
    }


}
