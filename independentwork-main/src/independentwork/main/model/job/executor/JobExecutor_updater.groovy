package independentwork.main.model.job.executor

import independentwork.main.model.sys.*
import independentwork.utils.dbfilestorage.DbFileStorageItem
import independentwork.utils.dbfilestorage.DbFileStorageService
import jandcode.dbm.dao.DaoMethod
import jandcode.dbm.data.DataRecord
import jandcode.dbm.data.DataStore
import jandcode.utils.UtCnv
import jandcode.utils.UtLang
import jandcode.wax.core.utils.upload.UploadFile

class JobExecutor_updater extends AppUpdaterDao {

    protected void onBeforeSave(DataRecord rec, boolean ins) throws Exception {
        long executor = rec.getValueLong("executor");
        long job = rec.getValueLong("job");

        DataStore store = ut.loadSql("""
            select id from JobExecutor 
            where executor = :executor
            and job = :job 
        """, UtCnv.toMap("executor", executor, "job", job));

        if (store.size() > 0) {
            ut.errors.addErrorFatal(UtLang.t("Обучаемый должен быть указан не более одного раза!"))
        }

    }

    @DaoMethod
    public void setAnswerFile(DataRecord record) {
        DataRecord rec = loadRec(record.getValue("id"));

        UploadFile uploadFile = (UploadFile) record.get("fn");
        if (uploadFile) {
            DbFileStorageService fstorage = model.service(DbFileStorageService);

            long oldFileId = rec.getValueLong("fileStorage");

            File f = new File(uploadFile.fileName)
            String fn = uploadFile.clientFileName.substring(uploadFile.clientFileName.lastIndexOf(String.valueOf("\\")) + 1);

            DbFileStorageItem md_file = fstorage.addFile(f, fn)
            rec.set("fileStorage", md_file.getId());
            rec.set("fileName", md_file.getOriginalFilename())

            ut.updateRec("JobExecutor", rec);

            if (oldFileId > 0) {
                fstorage.removeFile(oldFileId);
            }
        }
    }
}
