package independentwork.utils.dbfilestorage.model

import jandcode.dbm.dao.*
import jandcode.dbm.data.*
import jandcode.wax.core.model.*

class DbFileStorage_updater extends WaxUpdaterDao {

    @DaoMethod
    long getNextId() throws Exception {
        return ut.getNextId(ut.tableName)
    }

    protected long onIns(DataRecord rec) throws Exception {
        return ut.insertRec(ut.getTableName(), rec, false);
    }

}
