package independentwork.main.model.fd

import groovy.transform.*
import jandcode.utils.error.*
import jandcode.utils.rt.*

/**
 * Загрузчик данных предопределенного словаря из тега dictdata домена
 */
@CompileStatic
class FilledDictTreeDataLoader extends FilledDictDataLoader {
    private String parentFldNameXML = "par_ent";
    private String parentFldNameDB = "parent";

    protected void onLoad() throws Exception {
        Rt dd = getData().getDomain().getRt().findChild("dictdata");
        if (dd == null) {
            throw new XError("Для домена {0} не определен тег <dictdata>", getData().getDomain().getName())
        }
        //
        def st = getData()
        //
        for (x in dd.getChilds()) {
            def rec = st.add()
            for (a in x.attrs) {
                String fld = a.name;

                if (fld.equals( parentFldNameXML ) ) {
                    fld = parentFldNameDB;
                }

                if (rec.domain.findField( fld ) == null ) {
                    continue
                }

                rec.set(fld, a.value)
            }
            normalizeNames(rec)
        }

    }
}
