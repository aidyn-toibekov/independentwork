package independentwork.main.model.subject

import independentwork.main.model.sys.*
import jandcode.utils.UtCnv

class Subject_updater extends AppUpdaterDao {

    @Override
    protected void onBeforeDel(long id) {
        ut.execSql("delete SubjectUser where subject = :id", UtCnv.toMap("id",id));
    }
}
