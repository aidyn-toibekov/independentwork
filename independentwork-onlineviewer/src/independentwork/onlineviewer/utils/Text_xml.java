package independentwork.onlineviewer.utils;

import jandcode.onlineviewer.*;

import java.io.*;

/**
 * Обычный текст без всякого конвертирования
 */
public class Text_xml extends TextFileConvertor {
    public File getFile(FileInfo f) throws Exception {
        return new File(f.getFileData());
    }
}
