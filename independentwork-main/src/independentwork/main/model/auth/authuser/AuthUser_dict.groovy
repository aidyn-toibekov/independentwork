package independentwork.main.model.auth.authuser

import jandcode.dbm.dao.*
import jandcode.dbm.data.*
import jandcode.dbm.dict.*
import jandcode.utils.*
import jandcode.wax.core.model.*

class AuthUser_dict extends WaxDao implements ILoadDict {

    @DaoMethod
    void loadDict(jandcode.dbm.dict.Dict dict) {
        Set ids = dict.getResolveIds()
        DataStore res = dict.getData()
        //
        CollectionBlockIterator z = new CollectionBlockIterator(ids, 200);
        for (List itms : z) {
            String itmsS = UtString.join(itms, ",");
            String sql = "select * from ${ut.tableName} where id in (${itmsS})";
            ut.loadSql(res, sql);
        }
    }

}
