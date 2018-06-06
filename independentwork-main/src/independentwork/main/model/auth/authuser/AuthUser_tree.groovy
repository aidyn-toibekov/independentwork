package independentwork.main.model.auth.authuser

import independentwork.main.model.auth.UserInfoImplEx
import independentwork.main.model.sys.OrderByUtils
import independentwork.main.utils.SelectFieldUtils
import jandcode.auth.*
import jandcode.dbm.data.*
import jandcode.dbm.sqlfilter.*
import jandcode.wax.core.model.*

/**
 * Список
 */
class AuthUser_tree extends WaxLoadSqlFilterDao {

    private static long FD_Const_AuthUserType_User = 2
    private static long FD_Const_AuthUserType_Group = 1

    AuthUser_tree() {
        domainResult = "AuthUser.tree"
    }

    protected void onCreateFilter(SqlFilter f) {
        //
        f.filter(field: "parent", type: "parent", param: 'node', hidden: true)
        //
        String sOrderByName = OrderByUtils.getOrderByLangField("t.name", ut)
        String sOrderByFullName = OrderByUtils.getOrderByLangField("t.fullName", ut)

        f.orderBy("name", sOrderByName)
        f.orderBy("fullName", sOrderByFullName)
        //
        f.paginate = true

        // формируем список полей
        def sf = new SelectFieldUtils(ut)
        sf.addDomain("AuthUser", "t")
        //
        String cond = "0=0"
        if (!((UserInfoImplEx) app.service(AuthService).getCurrentUser()).isSysadmin()) {
            //если тек. пользователь не sysadmin, тогда пользователя sysadmin "скрываем"
            cond = "t.id != 1"
        }
        //
        f.sql = """select ${sf} from
                   AuthUser t
                   where ${cond} order by ${sOrderByName}
                """
    }

    protected DataStore onAfterLoad(SqlFilter f, DataStore t, boolean isLoadRec) {

        for (DataRecord r : t) {
            if (r.getValueLong("authUserType") == FD_Const_AuthUserType_Group) {
                r.setValue("leaf", false)
            } else {
                r.setValue("leaf", true)
                if (r.getValueBoolean("locked")) {
                    r.setValue("iconCls", "icon-cancel")
                } else {
                    r.setValue("iconCls", "icon-user")
                }
            }
        }

        return t

    }
}
