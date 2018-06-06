package independentwork.onlineviewer.utils

import independentwork.utils.dbfilestorage.DbFileStorageItem
import independentwork.utils.dbfilestorage.DbFileStorageService
import jandcode.dbm.ModelService
import jandcode.onlineviewer.FileProviderFileInfo
import jandcode.onlineviewer.impl.SystemFileProvider
import jandcode.utils.UtFile


class FileStorageProvider extends SystemFileProvider {

    /**
     *
     * @param path - это Ид FileStorage
     *
     * @param destFile
     * @param destFileInfo
     * @throws Exception
     */
    public void resolveFile(String path, File destFile, FileProviderFileInfo destFileInfo) throws Exception {

        long fsId = Long.parseLong( path );

        def model = app.service(ModelService.class).model;
        DbFileStorageService fstorage = model.service(DbFileStorageService.class);

        DbFileStorageItem f1 = fstorage.getFile(fsId);
        File fsf = f1.getFile();
        String apath = fsf.absolutePath;
        String ext = UtFile.ext(f1.originalFilename);
        //
        destFileInfo.setType(ext);
        destFileInfo.setLastModInfo("" + fsf.lastModified());

        OutputStream dstSt = new FileOutputStream(destFile);
        InputStream srcSt = new FileInputStream(apath);
        try {
            UtFile.copyStream(srcSt, destFile);
        } finally {
            srcSt.close();
            dstSt.close();
        }

    }

}
