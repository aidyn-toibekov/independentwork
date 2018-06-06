package independentwork.main.model.xmlgemerator;

import jandcode.dbm.test.*;
import jandcode.utils.easyxml.*;
import org.junit.*;

import java.io.*;

public class XmlGenerator extends DbmTestCase {

    @Test
    public void generate() throws Exception {
        File f = new File("C:\\temp\\journal\\xml\\");
        for (File file : f.listFiles()) {
            file.delete();
        }

        EasyXml xml = new EasyXml();
        xml.addChild("journal");



        xml.save().toFile("C:\\temp\\journal\\xml\\test.xml");
    }
}
