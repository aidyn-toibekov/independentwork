package independentwork.main.model.job.сompleting

import independentwork.main.model.sys.*
import jandcode.auth.*
import jandcode.dbm.sqlfilter.*
import jandcode.wax.core.model.*

class JobСompleting_list extends WaxLoadSqlFilterDao {

    JobСompleting_list() {
        domainResult = "JobCompleting"
        domainResult = "JobCompleting.filter"
    }

    protected void onCreateFilter(SqlFilter f) throws Exception {
        if(f.params.get("executor")==null){
            f.params.put("executor", getApp().service(AuthService.class).getCurrentUser().getId())
        }
        
        f.filter(field: "executor", type: "equal", sqlfields: 't.executor')

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
        f.sql = """
            select j.* from JobExecutor t
            inner join Job j on j.id = t.id
            where 0=0 order by t.id    
            """
    }

}
