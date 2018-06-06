package independentwork.main.model.auth.authuser


import independentwork.main.model.sys.AppUpdaterDao
import jandcode.auth.*
import jandcode.dbm.dao.*

class AuthUserPriv_updater extends AppUpdaterDao {

    @DaoMethod
    public void doUpdate(long userId, List privs) {

        updatePriv(userId, privs)

    }

    protected void deletePriv(long userId) {
        ut.execSql("delete from AuthUserPriv where authUser=:id", userId)
    }

    protected void updatePriv(long userId, List privs) {
        deletePriv(userId)
        //
        def svc = app.service(AuthService)
        for (Map r in privs) {
            String pname = r.get("id")
            if (svc.getPrivs().find(pname) == null) continue;
            def rec = [authUser: userId, permis: pname.toLowerCase()]
            if (r.get("busProcessBefore") != 0) {
                rec["busProcessBefore"] = r.get("busProcessBefore")
            }
            if (r.get("busProcessAfter") != 0) {
                rec["busProcessAfter"] = r.get("busProcessAfter")
            }
            ut.insertRec("AuthUserPriv", rec)
        }
    }

}
