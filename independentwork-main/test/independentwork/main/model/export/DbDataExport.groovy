package independentwork.main.model.export

import jandcode.dbm.Domain
import jandcode.dbm.Field
import jandcode.dbm.test.DbmTestCase
import jandcode.utils.easyxml.EasyXml
import org.junit.Test


class DbDataExport extends DbmTestCase {

    @Test
    public void export() {

        for (Domain domain : dbm.getModel().getDomains()) {
            if (domain.hasTag("db") && !domain.name.startsWith("FD") && !domain.name.startsWith("Db") && !domain.name.startsWith("Wax")) {
                String sql = "select * from ${domain.getName()} order by id"
                EasyXml xml = buildXml(sql);
                String fileName = app.getApp().getAppdir() + "\\independentwork-main\\src\\independentwork\\main\\dbdata\\prod\\"+domain.getName()+".xml";
                File f = new File(fileName);
                if(!f.exists()){
                    f.createNewFile();
                }
                xml.save().toFile(f);
            }
        }


    }

    private EasyXml buildXml(String sql) {

        def ds = dbm.ut.loadSql(sql);
        EasyXml x = new EasyXml();
        EasyXml x1;

        x.setName("root");
        for (r in ds) {
            String s = '';
            x1 = x.addChild("row");
            def flds = r.store.domain.fields;
            for (int i = 0; i < flds.size(); i++) {
                Field f = flds.get(i);
                String fldName = f.name;
                if (!r.isValueNull(fldName))
                    x1.attrs.setValue(fldName, r.get(fldName));
            }
        }
        return x;
    }
}
