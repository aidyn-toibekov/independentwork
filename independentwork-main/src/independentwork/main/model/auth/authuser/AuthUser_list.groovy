package independentwork.main.model.auth.authuser

import jandcode.dbm.sqlfilter.*
import jandcode.wax.core.model.*

class AuthUser_list extends WaxLoadSqlFilterDao {

    AuthUser_list() {
        domainResult = "AuthUser.list"
        domainFilter = "AuthUser.filter"
    }

    protected void onCreateFilter(SqlFilter f) throws Exception {
        f.filter(field: "name", type: "contains")
        f.filter(field: "fullName", type: "contains")
        f.filter(field: "locked", type: "equal")
        f.filter(field: "authUserRole", type: "equal", hidden:"true")

        //
        f.orderBy("id", "t.id")
        f.orderBy("name", "t.name")
        f.orderBy("fullName", "t.fullName")

        //
        f.paginate = true

        //
        f.sql = "select t.* from AuthUser t where t.id>0 order by t.id"
    }

}
