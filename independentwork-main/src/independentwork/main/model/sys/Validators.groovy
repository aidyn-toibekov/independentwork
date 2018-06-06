package independentwork.main.model.sys

import jandcode.dbm.*
import jandcode.dbm.data.*
import jandcode.dbm.dblang.*
import jandcode.lang.*
import jandcode.utils.*
import jandcode.wax.core.model.*

/**
 * Предназначен для общих валидаторов
 */
public class Validators {
/**
 * Проверяет валидность многоязычного наименовании
 * @param rec Запись
 * @param ut Утилиты для dao объектов
 * @param fieldName имя валидируемого поля
 */

    public static void langFieldValidate(DataRecord rec, WaxDaoUtils ut, String fieldName, boolean ins) {

        Field f = rec.getDomain().findField(fieldName);
        if (!f) return;

        // Получаем текст условии на запрос
        String nameCondition = getNameCondition(rec, "t",fieldName, ut)
        //Получаем параметры которые нужно передать
        Map params = getConditionParams(rec, fieldName, ut)
        // Вставим параметр ИД
        params.put("id", rec.get("id"))

        DataStore ds = ut.loadSql("""
                select t.id
                from ${ut.tableName} t
                where (${nameCondition})
                    and not t.id = :id
            """, params)

        if (ds.size() > 0) {
            ut.errors.addErrorFatal(UtLang.t("Значение поля ["+f.title+"] не уникально."))
        }


    }

/**
 * Проверяет валидность по дате новой версий объекта
 * @param rec Запись
 * @param ut Утилиты для dao объектов
 * @param params Дополнительные параметры при запросе, пример в main.model.classifier.serviceProvider
 */
    public static void actualDateValidate(DataRecord rec, WaxDaoUtils ut, Map params){
        Field f = rec.getDomain().findField("dbeg");
        if (!f) return;
        Field f1 = rec.getDomain().findField("dend");
        if (!f1) return;

        String strDbeg =rec.getValueDateTime("dbeg").toString("yyyy-MM-dd")
        String strDend =rec.getValueDateTime("dend").toString("yyyy-MM-dd")

        String sql ="""
        select t.*
        from ${ut.tableName} t
        where """
        if (params){
            String tempStr="";
        for (Map.Entry entry : params.entrySet()){
            tempStr = tempStr + " and "+entry.getKey()+"="+entry.getValue()
        }
            sql = sql + "0=0"+ tempStr+ " and "
        }
        sql = sql +"""
        (
        (t.dbeg between ' ${strDbeg}' and '${strDend}')
        or
        (t.dend between '${strDbeg}' and '${strDend} ')
        or
        ('${strDbeg}' between t.dbeg and t.dend)
        or
        ('${strDend}' between t.dbeg and t.dend)
        )

        and t.id <> ${rec.get("id")}
        """
        DataStore ds = ut.loadSql(sql)
        if (ds.size()>0) {
            String Message;
            if (ds.size()==1){
                Message = "Имеется другая версия актуальностью "
            } else{
                Message = "Имеются другие версии актуальностью "
            }
            for (DataRecord r : ds) {
                Message = Message + " c "+r.get("dbeg") + " по "+ r.get("dend")+ " \n"
                }
            ut.errors.addErrorFatal(Message);
        }


    }



    /**
     * @param rec запись
     * @param ut утелиты
     * @return возвращает параметры которые нужны при загрузке запроса
     */
    public static Map getConditionParams(DataRecord rec, String fieldName, WaxDaoUtils ut) {
        Map params = new HashMap()
        DblangService svc = ut.getModel().getDblangService();

        // Если поле заполнено вставим в параметр
        for (Lang lang : svc.getLangs()) {

            String name = fieldName + "_" + lang.getName()

            if (!rec.getValueString(name).equals("")) {
                params.put(name, rec.get(name))
            }
        }

        return params
    }

    /**
     * @param rec Запись
     * @param alias Алияс таблицы
     * @param ut Утилиты для dao объектов
     * @param fieldName Имя поля для валидации.
     * @return Метод возвращает текст условия на запрос для валидатора наименовании
     * Например:
     *          0=1
     *          or LOWER(vt.fieldName_ru)=LOWER(:fieldName_ru)
     *          or LOWER(vt.fieldName_kz)=LOWER(:fieldName_kz)
     *          or LOWER(vt.fieldName_en)=LOWER(:fieldName_en)
     */
    public static String getNameCondition(DataRecord rec, String alias, String fieldName, WaxDaoUtils ut) {
        String condition = "0=1"

        DblangService svc = ut.getModel().getDblangService();

        for (Lang lang : svc.getLangs()) {

            String name = fieldName + "_" + lang.getName()

            if (!rec.getValueString(name).equals("")) {
                condition = condition + " or LOWER(" + alias + "." + name +
                        ")=LOWER(:" + name + ")"
            }
        }
        return condition
    }

}

