package independentwork.onlineviewer.model

import jandcode.dbm.dao.*
import jandcode.dbm.data.*
import jandcode.wax.core.model.*
import jandcode.web.*

class DemoFiles_list extends WaxDao {

    protected void loadDir(DataStore st, String dir) {
        def lst = app.service(WebService).resourceService.virtualDir.findFiles(dir)
        for (f in lst) {
            if (f.isDir()) {
                continue
            }
            st.add(id: st.size() + 1, path: f.virtualPath)
        }
    }

    @DaoMethod
    public DataStore load() throws Exception {
        DataStore st = ut.createStore("DemoFiles")
        loadDir(st, "data")
        return st
    }

}
