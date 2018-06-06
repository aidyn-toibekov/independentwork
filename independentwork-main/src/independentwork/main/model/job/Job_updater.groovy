package independentwork.main.model.job

import independentwork.main.model.sys.*
import independentwork.utils.dbfilestorage.DbFileStorageItem
import independentwork.utils.dbfilestorage.DbFileStorageService
import jandcode.auth.AuthService
import jandcode.dbm.data.DataRecord
import jandcode.utils.UtLang
import jandcode.wax.core.utils.upload.UploadFile
import org.joda.time.DateTime

class Job_updater extends AppUpdaterDao {

    @Override
    DataRecord newRec() throws Exception {
        DataRecord record = super.newRec();
        record.setValue("dte", DateTime.now());
        record.setValue("author", getApp().service(AuthService.class).getCurrentUser().getId());
        return record;
    }

    protected void onBeforeSave(DataRecord rec, boolean ins) throws Exception {
        if (rec.getValueLong("subject") == 0) {
            ut.errors.addErrorFatal(UtLang.t("Укажите предмет!"))
        }


        UploadFile uploadFile = (UploadFile) rec.get("fn");
        if (uploadFile) {
            DbFileStorageService fstorage = model.service(DbFileStorageService);
            if (!ins) {
                if (rec.getValueLong("fileStorage") > 0) {
                    DbFileStorageItem oldFile = fstorage.getFile(rec.getValueLong("fileStorage"))
                    String fn = uploadFile.clientFileName.substring(uploadFile.clientFileName.lastIndexOf(String.valueOf("\\")) + 1);
                    if (!oldFile.originalFilename.equals(fn)) {
                        fstorage.removeFile(rec.getValueLong("fileStorage"));
                        addFile(rec);
                    }
                }
            } else {
                addFile(rec)
            }
        }


    }

    private void addFile(DataRecord rec) {
        DbFileStorageService fstorage = model.service(DbFileStorageService);
        UploadFile uploadFile = (UploadFile) rec.get("fn");
        if (uploadFile) {
            File f = new File(uploadFile.fileName)
            String fn = uploadFile.clientFileName.substring(uploadFile.clientFileName.lastIndexOf(String.valueOf("\\")) + 1);

            DbFileStorageItem md_file = fstorage.addFile(f, fn)
            rec.set("fileStorage", md_file.getId());
            rec.set("fileName", md_file.getOriginalFilename())
        }
    }

    protected void onBeforeDel(long id) {
        ut.execSql("delete JobExecutor where job = :id", ["id": id]);
    }
}
