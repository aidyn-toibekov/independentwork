package independentwork.main.model.auth.authrole

import independentwork.main.utils.SelectFieldUtils
import jandcode.auth.*
import jandcode.dbm.dao.*
import jandcode.dbm.data.*
import jandcode.dbm.sqlfilter.*
import jandcode.utils.*
import jandcode.wax.core.model.*

/**
 * Привелегии роли
 */
class AuthRole_priv extends WaxDao {

    protected DataStore loadPrivs() {
        DataStore t = ut.createStore("AuthRole.privtree");
        def privs = app.service(AuthService).getPrivs();
        for (p in privs) {
            def exp = UtString.empty(p.parentName)
            t.add([id: p.name, parent: p.parentName, text: UtLang.t(p.title), checked: false, expanded: exp])
        }
        return t
    }

    protected DataStore loadPrivs2() {
        DataStore t = ut.createStore("AuthRole.privtree2");
        def privs = app.service(AuthService).getPrivs();
        for (p in privs) {
            boolean acceptBusProcess = false
            if (p.name.split(":").size() > 1) {
                acceptBusProcess = true
            }
            t.add([id: p.name, parent: p.parentName, text: UtLang.t(p.title), checked: false, acceptBusProcess: acceptBusProcess])
        }
        return t
    }

    /**
     * Грузит пустое дерево привелегий
     */
    @DaoMethod
    public DataTreeNode loadEmptyTree() throws Exception {
        DataStore t = loadPrivs()
        return UtData.createTreeIdParent(t, "id", "parent")
    }

    @DaoMethod
    public DataTreeNode loadRolePrivs(Map params) {
        DataStore ds = getData(params)
        def dsidx = UtData.createIndex(ds, "permis")

        DataStore t = ut.createStore("AuthRole.privtree2");
        def privs = app.service(AuthService).getPrivs();
        for (p in privs) {
            def a1 = dsidx.get(p.name)
            if (a1 != null) {
                boolean acceptBusProcess = false
                if (p.name.split(":").size() > 1) {
                    acceptBusProcess = true
                }
                t.add([
                        id: p.name,
                        parent: p.parentName,
                        text: UtLang.t(p.title),
                        checked: null,
                        acceptBusProcess: acceptBusProcess,
                        busProcessBefore: a1.getValueLong("busProcessBefore"),
                        busProcessAfter: a1.getValueLong("busProcessBefore"),
                        busProcessBeforeName: a1.getValueString("busProcessBeforeName"),
                        busProcessAfterName: a1.getValueString("busProcessAfterName"),
                        expanded: true
                ])
            }
        }
        return UtData.createTreeIdParent(t, "id", "parent")
    }

    /**
     * Грузит дерево привелегий для роли с учетом доступа через бизнес правила
     */
    @DaoMethod
    public DataTreeNode load(Map params) throws Exception {
        long roleId = params.get("id")
        DataStore t = loadPrivs2()
        if (roleId > 0) {
            DataStore rp = getData(params)
            def tidx = UtData.createIndex(t, "id")
            for (r in rp) {
                def privName = r.getValueString("permis")
                def a1 = tidx.get(privName)
                if (a1 != null) {
                    a1["busProcessBefore"] = r.getValueLong("busProcessBefore")
                    a1["busProcessAfter"] = r.getValueLong("busProcessAfter")
                    a1["busProcessBeforeName"] = r.getValueString("busProcessBeforeName")
                    a1["busProcessAfterName"] = r.getValueString("busProcessAfterName")
                    a1["checked"] = true
                }
            }
        }
        return UtData.createTreeIdParent(t, "id", "parent")
    }

    /**
     * Строит сторе с бизнес процессами для переданной в параметрах roleId роли
     */
    protected DataStore getData(Map params) {
        SqlFilter f = ut.createSqlFilter("AuthRolePriv.busProcessName", params);

        f.filter(field: "authRole", type: "equal", param: 'id')

        def sf = new SelectFieldUtils(ut)
        sf.addDomain("AuthRolePriv", "a")
        sf.addFieldLang("busProcessBeforeName", "bb", "name")
        sf.addFieldLang("busProcessAfterName", "ba", "name")

        f.sql = """
        select ${sf}
        from AuthRolePriv a left join BusProcess bb on a.busprocessbefore=bb.id
        left join BusProcess ba on a.busprocessafter=ba.id
        where 0=0
        """

        DataStore res = ut.createStore("AuthRolePriv.busProcessName");
        f.load(res)
        return res
    }

}
