package independentwork.main.model.subject

import independentwork.main.model.sys.*
import jandcode.dbm.data.DataRecord
import jandcode.dbm.data.DataStore
import jandcode.utils.UtCnv
import jandcode.utils.UtLang

class SubjectUser_updater extends AppUpdaterDao {

    protected void onBeforeSave(DataRecord rec, boolean ins) throws Exception {
        long authUser = rec.getValueLong("authUser");
        long subject = rec.getValueLong("subject");

        DataStore store = ut.loadSql("""
            select id from SubjectUser 
            where authUser = :authUser
            and subject = :subject 
        """, UtCnv.toMap("authUser", authUser, "subject", subject));

        if(store.size()>0){
            ut.errors.addErrorFatal(UtLang.t("Преподаватель для каждого предмета должен быть указан не более одного раза!"))
        }

    }
}
