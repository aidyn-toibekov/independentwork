package independentwork.main.utils;

import jandcode.dbm.*;
import jandcode.dbm.db.*;
import jandcode.dbm.dblang.*;
import jandcode.lang.*;
import jandcode.utils.*;

/**
 * Формирование списка полей для sql оператора select.
 * При использовании стоит учитывать некоторые моменты:
 * утилиты формируют список полей, которые будут результатом select. Т.е. при добавлении
 * поля мы указываем под каким именем оно будет в результате. А вот к этому имени
 * мы можем присоеденить дополнительную информацию: алиас таблицы и реaльное имя поля.
 * Правила такие:
 * add-field('name1')  -> name1
 * add-field('name1','alias1')  -> alias1.name1
 * add-field('name1','alias1','realname1')  -> alias1.realname1 as name1
 */
public class SelectFieldUtils {

    protected DbUtils ut;

    protected ListNamed<FieldItem> fields = new ListNamed<FieldItem>();

    /**
     * Имя объекта - имя выходного поля (алиаса поля)
     */
    public class FieldItem extends Named {
        String alias;
        String realField;

        FieldItem(String name, String alias, String realField) {
            this.name = name;
            this.alias = alias;
            this.realField = realField;
        }

        public String toString() {
            String s = "";
            if (!UtString.empty(alias)) {
                s = alias + ".";
            }
            if (!UtString.empty(realField) && !realField.equalsIgnoreCase(getName())) {
                s = s + realField + " as " + getName();
            } else {
                s = s + getName();
            }
            return s;
        }

        public String getAlias() {
            return alias;
        }

        public void setAlias(String alias) {
            this.alias = alias;
        }

        public String getRealField() {
            return realField;
        }

        public void setRealField(String realField) {
            this.realField = realField;
        }
    }

    public SelectFieldUtils(DbUtils ut) {
        this.ut = ut;
    }

    public void clear() {
        fields.clear();
    }

    public String toString() {
        StringBuilder b = new StringBuilder();
        for (FieldItem f : fields) {
            if (b.length() > 0) {
                b.append(',');
            }
            b.append(f);
        }
        return b.toString();
    }

    public ListNamed<FieldItem> getFields() {
        return fields;
    }

    //////

    /**
     * Добавляет все поля из домена с реальными именами и указанным алиасом.
     * Если поле уже есть в списке, попытка добавить игнорируется.
     *
     * @param domainName имя домена
     * @param alias      алиас для полей
     */
    public void addDomain(String domainName, String alias) {
        Domain d = ut.getModel().getDomain(domainName);
        for (Field f : d.getFields()) {
            if (f.isCalc()) {
                // вычисляемые пропускаем
                continue;
            }
            if (fields.find(f.getName()) != null) {
                // поле с таким именем уже включено
                continue;
            }
            FieldItem z = new FieldItem(f.getName(), alias, null);
            fields.add(z);
        }
    }

    //////

    /**
     * Добавить поле. Если поле имеется - заменяется.
     *
     * @param name     имя результата
     * @param alias    алиас таблицы
     * @param realName реальное имя поля из алиаса таблицы
     */
    public void addField(String name, String alias, String realName) {
        FieldItem z = new FieldItem(name, alias, realName);
        fields.add(z);
    }

    /**
     * Добавить поле. Если поле имеется - заменяется.
     *
     * @param name  имя результата
     * @param alias алиас таблицы
     */
    public void addField(String name, String alias) {
        addField(name, alias, null);
    }

    /**
     * Добавить поле. Если поле имеется - заменяется.
     *
     * @param name имя результата
     */
    public void addField(String name) {
        addField(name, null, null);
    }

    /**
     * Удалить поле из списка
     */
    public void removeField(String name) {
        fields.remove(name);
    }

    /**
     * Добавить мультиязыковое поле. Если поле имеется - заменяется.
     *
     * @param name     имя результата
     * @param alias    алиас таблицы
     * @param realName реальное имя поля из алиаса таблицы
     */
    public void addFieldLang(String name, String alias, String realName) {
        DblangService svc = ut.getModel().getDblangService();
        for (Lang lang : svc.getLangs()) {
            String nm = name + "_" + lang.getName();
            String rn = null;
            if (!UtString.empty(realName)) {
                rn = realName + "_" + lang.getName();
            }
            FieldItem z = new FieldItem(nm, alias, rn);
            fields.add(z);
        }
    }

    /**
     * Добавить мультиязыковое поле. Если поле имеется - заменяется.
     *
     * @param name  имя результата
     * @param alias алиас таблицы
     */
    public void addFieldLang(String name, String alias) {
        addFieldLang(name, alias, null);
    }

    /**
     * Добавить мультиязыковое поле. Если поле имеется - заменяется.
     *
     * @param name имя результата
     */
    public void addFieldLang(String name) {
        addFieldLang(name, null, null);
    }

}
