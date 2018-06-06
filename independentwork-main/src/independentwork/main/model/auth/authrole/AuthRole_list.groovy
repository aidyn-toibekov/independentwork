package independentwork.main.model.auth.authrole

import independentwork.main.model.sys.OrderByUtils
import jandcode.dbm.sqlfilter.*
import jandcode.wax.core.model.*

class AuthRole_list extends WaxLoadSqlFilterDao {

    AuthRole_list() {
        domainResult = "AuthRole"
        domainFilter = "AuthRole.filter"
    }

    protected void onCreateFilter(SqlFilter f) throws Exception {
        f.filter(field: "name", type: "contains", sqlfields: '*t.name,*t.fullName')
        f.filter(field: "cmt", type: "contains")
        //
        String sOrderByName = OrderByUtils.getOrderByLangField("t.name", ut)
        String sOrderByFullName = OrderByUtils.getOrderByLangField("t.fullName", ut)
        //
        f.orderBy("name", sOrderByName)
        f.orderBy("fullName", sOrderByFullName)
        //
        f.paginate = true
        //
        f.sql = "select t.* from AuthRole t where 0=0 order by t.id"
    }

}
