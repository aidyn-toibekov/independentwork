package independentwork.main.model.subject

import independentwork.main.model.sys.OrderByUtils
import jandcode.dbm.data.DataRecord
import jandcode.dbm.sqlfilter.*
import jandcode.utils.UtCnv
import jandcode.wax.core.model.*

class SubjectUser_list extends WaxLoadSqlFilterDao {

    SubjectUser_list() {
        domainResult = "SubjectUser"
        domainFilter = "SubjectUser.filter"
    }

    protected void onCreateFilter(SqlFilter f) throws Exception {

        f.filter(field: "authUser", type: "equal")
        f.filter(field: "subject", type: "equal")

        String sOrderByName = OrderByUtils.getOrderByLangField("a.name", ut)

        f.orderBy("name", sOrderByName)

        f.sql = """
                select t.* from SubjectUser t 
                inner join AuthUser a on a.id = t.authUser
                where 0=0 order by t.id
                """
    }

    @Override
    public DataRecord loadRec(long id) throws Exception {
        return ut.loadSqlRec("""
                select t.* from SubjectUser t 
                inner join AuthUser a on a.id = t.authUser
                where t.id = :id
        """, UtCnv.toMap("id", id));
    }
}
