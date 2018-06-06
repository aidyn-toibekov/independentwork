package independentwork.main.model.fd

import groovy.transform.*
import jandcode.dbm.dao.*
import jandcode.dbm.data.*
import jandcode.wax.core.model.*

/**
 * Загрузчик данных предопределенного словаря из тега dictdata домена
 */
@CompileStatic
class WaxLoadDictTreeDao extends WaxDao {
    @DaoMethod
    public DataTreeNode load(Map pms){
        String sql = """
            select * from ${ut.tableName}
        """;
        def st = ut.createStore(ut.tableName);
        ut.loadSql(st, sql);
        def dtn = ut.createTreeIdParent(st,'id','parent');
        //

        return dtn;
    }
}
