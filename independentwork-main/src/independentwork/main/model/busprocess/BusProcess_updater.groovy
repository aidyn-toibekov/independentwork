package independentwork.main.model.busprocess

import groovy.transform.*
import independentwork.main.model.sys.AppUpdaterDao
import independentwork.main.model.sys.FD_Const
import independentwork.main.utils.SelectFieldUtils
import jandcode.dbm.dao.*
import jandcode.dbm.data.*
import jandcode.dbm.sqlfilter.*
import jandcode.utils.*

@CompileStatic
class BusProcess_updater extends AppUpdaterDao {

    protected void onBeforeDel(long id) {
        checkGroup(id)
        checkUsage(id)
    }

    /**
     * Проверяет группу на содержимое
     */
    protected void checkGroup(long id) {
        DataRecord rec = loadRec(id)
        if (rec.getValueLong("busProcessType") == FD_Const.BusProcessType_group) {
            DataStore ds = ut.loadSql("select * from BusProcess t where t.parent=:id", [id: id])
            if (ds.size() > 0) {
                ut.errors.addErrorFatal(UtLang.t("Данная группа бизнес-процессов содержит элементы"))
            }
        }
    }

    protected void checkUsage(long id) {
        DataStore dsU = ut.loadSql("select * from AuthUserPriv u where u.busProcessBefore=:id or u.busProcessAfter=:id", [id: id])
        DataStore dsR = ut.loadSql("select * from AuthRolePriv r where r.busProcessBefore=:id or r.busProcessAfter=:id", [id: id])

        if (dsU.size() > 0 || dsR.size() > 0) {
            ut.errors.addErrorFatal(UtLang.t("Данный бизнес-процесс используется"))
        }
    }

    @DaoMethod
    public DataStore loadCbStore() {

        SqlFilter f = ut.createSqlFilter("FD_BusProcessType", [:]);

        def sf = new SelectFieldUtils(ut)
        sf.addField("id", "t")
        sf.addFieldLang("name", "t", "name")
        sf.addFieldLang("fullName", "t", "fullName")

        f.sql = "select ${sf} from FD_BusProcessType t where t.id!=1"

        DataStore res = ut.createStore("FD_BusProcessType");
        f.load(res)
        return res

    }
}
