package independentwork.main.model.job

import independentwork.main.model.sys.*
import jandcode.auth.AuthService
import jandcode.dbm.sqlfilter.*
import jandcode.wax.core.model.*

class Job_list extends WaxLoadSqlFilterDao {

    Job_list() {
        domainResult = "Job"
        domainResult = "Job.filter"
    }

    protected void onCreateFilter(SqlFilter f) throws Exception {
        if(f.params.get("author")==null){
            f.params.put("author", getApp().service(AuthService.class).getCurrentUser().getId())
        }
        
        f.filter(field: "author", type: "equal")

        f.filter(field: "name", type: "contains", sqlfields: '*t.name,*t.fullName')
        f.filter(field: "cmt", type: "contains")

        f.filter(field: "subject", type: "equal")
        //
        String sOrderByName = OrderByUtils.getOrderByLangField("t.name", ut)
        String sOrderByFullName = OrderByUtils.getOrderByLangField("t.fullName", ut)
        //
        f.orderBy("dte", "t.dte desc")
        f.orderBy("name", sOrderByName)
        f.orderBy("fullName", sOrderByFullName)
        //
        f.paginate = true
        //
        f.sql = "select t.* from Job t where 0=0 order by t.id"
    }

}
