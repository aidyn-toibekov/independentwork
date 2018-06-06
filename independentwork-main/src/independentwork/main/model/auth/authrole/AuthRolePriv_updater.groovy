package independentwork.main.model.auth.authrole

import independentwork.main.model.sys.*
import jandcode.auth.*
import jandcode.dbm.dao.*

class AuthRolePriv_updater extends AppUpdaterDao {

    @DaoMethod
    public void doUpdate(long roleId, List privs) {

        updatePriv(roleId, privs)

    }

    protected void deletePriv(long roleId) {
        ut.execSql("delete from AuthRolePriv where authRole=:id", roleId)
    }

    protected void updatePriv(long roleId, List privs) {
        deletePriv(roleId)
        //
        def svc = app.service(AuthService)
        for (Map r in privs) {
            String pname = r.get("id")
            if (svc.getPrivs().find(pname) == null) continue;
            def rec = [authRole: roleId, permis: pname.toLowerCase(), accessLevel: r.get("accessLevel")]
            if (r.get("busProcessBefore") != 0) {
                rec["busProcessBefore"] = r.get("busProcessBefore")
            }
            if (r.get("busProcessAfter") != 0) {
                rec["busProcessAfter"] = r.get("busProcessAfter")
            }
            ut.insertRec("AuthRolePriv", rec)
        }
    }

}
