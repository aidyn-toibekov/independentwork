package independentwork.main.model.busprocess

import independentwork.main.model.sys.OrderByUtils
import independentwork.main.utils.SelectFieldUtils
import jandcode.dbm.data.*
import jandcode.dbm.sqlfilter.*
import jandcode.wax.core.model.*

/**
 * Список
 */
class BusProcess_tree extends WaxLoadSqlFilterDao {


    BusProcess_tree() {
        domainResult = "BusProcess.tree"
    }

    protected void onCreateFilter(SqlFilter f) {
        //
        f.filter(field: "parent", type: "parent", param: 'node', hidden: true)

        f.filter(field: "name", type: "contains", sqlfields: '*t.name,*t.fullName')
        //
        String sOrderByName = OrderByUtils.getOrderByLangField("t.name", ut)
        String sOrderByFullName = OrderByUtils.getOrderByLangField("t.fullName", ut)

        //
        f.orderBy("name", sOrderByName)
        f.orderBy("fullName", sOrderByFullName)

        // формируем список полей
        def sf = new SelectFieldUtils(ut)
        sf.addDomain("BusProcess", "t")

        f.sql = """select ${sf} from
                   BusProcess t
                   where 0=0 order by ${sOrderByName}
                """
    }

    protected DataStore onAfterLoad(SqlFilter f, DataStore t, boolean isLoadRec) {
        long checkId = f.params.containsKey("checkId") ? f.params.get("checkId") : 0

        boolean hideCheck = f.params["hideCheck"]
        if (isLoadRec)
            hideCheck = true

        for (DataRecord r : t) {
            if (r.getValueLong("busProcessType") == 1) {
                r.set("leaf", false)
                r.set("checked", null)
            } else {
                r.set("leaf", true)
                r.setValue("iconCls", "icon-busprocess")
                if (!hideCheck)
                    if (r.getValueLong("id") == checkId) {
                        r.set("checked", true)
                    } else {
                        r.set("checked", false)
                    }
            }
        }

        return t
    }

}
