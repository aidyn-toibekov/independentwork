package independentwork.main.model.fd

import jandcode.dbm.dataloader.*

/**
 * Загрузчик словаря FD_TofiEntity
 */
class EntityDataLoader extends DataLoader {

    protected void onLoad() throws Exception {
        def st = getData()
        for (e in EntityConst.getEntityInfos()) {
            st.add(id: e.numConst, name_ru: e.name,
                    fullName_ru: e.name, tableName: e.tableName, ord: e.numConst, vis: 1)
        }
    }

}
