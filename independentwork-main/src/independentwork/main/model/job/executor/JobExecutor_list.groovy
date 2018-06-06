package independentwork.main.model.job.executor

import independentwork.main.model.sys.*
import jandcode.dbm.sqlfilter.*
import jandcode.wax.core.model.*

class JobExecutor_list extends WaxLoadSqlFilterDao {

    JobExecutor_list() {
        domainResult = "JobExecutor.full"
        domainFilter= "JobExecutor.filter"
    }

    protected void onCreateFilter(SqlFilter f) throws Exception {
        f.filter(field: "name", type: "contains", sqlfields: '*t.name,*t.fullName')

        f.filter(field: "job", type: "equal")
        f.filter(field: "subject", type: "equal")
        //
        String sOrderByName = OrderByUtils.getOrderByLangField("t.name", ut)
        //
        f.orderBy("dte", "t.dte desc")
        f.orderBy("name", sOrderByName)

        //
        f.sql = """
                select t.*, 
                case when coalesce(fileStorage,0)> 0 then 1 else 0 end as hasAnswer
                from JobExecutor t 
                where 0=0 order by t.id
                """
    }

}
