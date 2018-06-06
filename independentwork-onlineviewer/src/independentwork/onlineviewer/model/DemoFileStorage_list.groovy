package independentwork.onlineviewer.model

import jandcode.dbm.dao.*
import jandcode.dbm.data.*
import jandcode.wax.core.model.*
import jandcode.web.*

class DemoFileStorage_list extends WaxDao {

    protected void loadDir( DataStore st ) {
        st.add(id: 1000,name:'safdgasdf', dbfs:1000);
    }

    @DaoMethod
    public DataStore load() throws Exception {
        DataStore st = ut.createStore("DemoFileStorage")
        loadDir(st)
        return st
    }

}
