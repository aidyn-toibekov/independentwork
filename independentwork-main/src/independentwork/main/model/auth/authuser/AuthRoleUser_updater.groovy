package independentwork.main.model.auth.authuser

import independentwork.main.model.sys.AppUpdaterDao
import jandcode.dbm.dao.*
import jandcode.dbm.data.*

class AuthRoleUser_updater extends AppUpdaterDao {

    @DaoMethod
    public void doUpdate(long userId, DataStore store) {

        ut.execSql("delete from AuthRoleUser where authUser = :userId", [userId: userId])

        int ord = 1;
        for (DataRecord r : store) {
            DataRecord newRec = newRec();
            newRec.setValue("authRole", r.getValueLong("id"))
            newRec.setValue("authUser", userId)
            newRec.setValue("ord", ord)
            ins(newRec)
            ord++
        }

    }

}
