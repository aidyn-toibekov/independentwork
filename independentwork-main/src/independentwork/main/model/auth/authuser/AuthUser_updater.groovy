package independentwork.main.model.auth.authuser

import independentwork.main.model.auth.UserInfoImplEx
import independentwork.main.model.sys.AppUpdaterDao
import independentwork.main.model.sys.FD_Const
import independentwork.main.model.sys.OrderByUtils
import independentwork.main.utils.SelectFieldUtils
import jandcode.auth.*
import jandcode.dbm.dao.*
import jandcode.dbm.data.*
import jandcode.dbm.sqlfilter.*
import jandcode.utils.*
import jandcode.utils.error.*

import java.util.regex.*

class AuthUser_updater extends AppUpdaterDao {

    protected void validatePassword(DataRecord t) {
        String p1 = t.getValueString("passwd");
        String p2 = t.getValueString("passwd2");
        //
        if (UtString.empty(p1)) {
            ut.getErrors().addError("Пароль не введен", "passwd");
            return;
        }
        if (p1 != p2) {
            ut.getErrors().addError("Пароли не совпадают", "passwd");
        }
    }

    protected void deleteRole(long userId) {
        DataStore store = ut.loadSql("select * from AuthRoleUser where authUser=:id", userId)
        ut.execSql("delete from AuthRoleUser where authUser=:id", userId)
    }

    protected void updateRole(long userId, String roleIds) {
        deleteRole(userId)
        //
        def roles = roleIds.split(",")
        for (rid in roles) {
            def rid_num = UtCnv.toLong(rid)
            if (rid_num == 0) continue;
            ut.insertRec("AuthRoleUser", [authRole: rid_num, authUser: userId])
        }
    }

    protected void onBeforeSave(DataRecord rec, boolean ins) throws Exception {
        super.onBeforeSave(rec, ins);
        if (!ins) {
            checkSysadmin(rec)
        }
        checkLogin(rec, ins)
//        checkName(rec, ut, true)
        checkEmail(rec)
        checkPhoneNumber(rec)
    }


    protected void checkLogin(DataRecord rec, boolean ins) {
        //todo изменить на значение FD_AuthUserType_User
        long authUserType_User = 2
        if (rec.getValueLong("authUserType") == authUserType_User) {

            if (UtString.empty(rec.getValueString("login")))
                ut.errors.addErrorFatal(UtLang.t("Значение для поля [{0}] обязательно", rec.getDomain().findField("login").title), "login")

            if (!ins) {
                DataRecord oldRec = ut.loadRec(ut.tableName, rec.getValueLong("id"))
                if (rec.getValueString("login").toLowerCase().equals(oldRec.getValueString("login").toLowerCase())) return
            }
            DataStore ds = ut.loadSql("select * from AuthUser t where LOWER(t.login)=LOWER(:login)", [login: rec.getValueString("login")])
            if (ds.size() > 0)
                ut.errors.addErrorFatal(UtLang.t("Пользователь с таким логином уже существует"), "login")
        }
    }

    protected void checkEmail(DataRecord rec) {
        if (rec.getValueString("email") == "") return

        String email = rec.getValueString("email")
        Pattern p = Pattern.compile("^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})\$")
        Matcher m = p.matcher(email)

        if (!m.matches()) {
            ut.errors.addErrorFatal(UtLang.t("Неправильное значение для поля [{0}]", rec.getDomain().findField("email").title), "email")
        }
    }

    protected void checkPhoneNumber(DataRecord rec) {
        if (rec.getValueString("phoneNumber") == "") return

        String phoneNumber = rec.getValueString("phoneNumber")
        Pattern p = Pattern.compile("^[0-9-\\+() ]+\$")
        Matcher m = p.matcher(phoneNumber)

        if (!m.matches()) {
            ut.errors.addErrorFatal(UtLang.t("Неправильное значение для поля [{0}]", rec.getDomain().findField("phoneNumber").title), "phoneNumber")
        }
    }

    protected void checkSysadmin(DataRecord rec) {
        if (rec.getValueLong("id") == 1 && !((UserInfoImplEx) app.service(AuthService).getCurrentUser()).isSysadmin()) {
            ut.errors.addErrorFatal(UtLang.t("У вас недостаточно прав"))
        }
    }

    protected void onBeforeDel(long id) throws Exception {
        DataRecord th = loadRec(id);
        long authUserType = th.getValueLong("authUserType");
        if (authUserType == FD_Const.AuthUserType_group) {
            DataStore countChilds = ut.loadSql("select distinct authUserType as aut from AuthUser t where t.parent =:id", [id: id]);
            if (countChilds.size() > 0) {
                ut.errors.addError(UtLang.t("{0} имеет элементы", th.getValueString("name")))
                ut.checkErrors()
            }
        } else {
            DataStore ds = ut.loadSql("select *  from AuthRoleUser where authuser=:id", [id: id])


            DataStore ds1 = ut.loadSql("select *  from AuthUserPriv where authuser=:id", [id: id])


            ut.execSql("delete from AuthRoleUser where authuser=:id", [id: id])
            ut.execSql("delete from AuthUserPriv where authuser=:id", [id: id])
        }
    }

    @DaoMethod
    public long ins(DataRecord data) throws Exception {
        DataRecord t = ut.createRecord("AuthUser.edit", data);
        //
        onBeforeSave(data, true)
        ut.validateRecord(t, "ins");
        if (data.getValueLong("authUserType") != 1) {
            validatePassword(t)
        }
        ut.checkErrors();
        //
        t.setValue("passwd", UtString.md5Str(data.getValueString("passwd")));
        long id = ut.insertRec(ut.getTableName(), t);
        updateRole(id, t.getValueString("roles"))
        return id
    }

    /**
     * Обновление всего, кроме пароля
     */
    @DaoMethod
    public void upd(DataRecord data) throws Exception {
        DataRecord t = ut.createRecord("AuthUser.edit", data);
        //
        onBeforeSave(data, false)
        ut.validateRecord(t, "upd");
        ut.checkErrors();
        //
        ut.updateRec(ut.getTableName(), t, null, ['passwd', 'passwd2', 'roles']);
        updateRole(t.getValueLong("id"), t.getValueString("roles"))
    }

    /**
     * Физическое удаление пользователя
     */
    @DaoMethod
    public void del(long id) throws Exception {
        //
        if (id <= 1) throw new XError(UtLang.t("Системного пользователя удалить нельзя"));
        //
        onBeforeDel(id)
        ut.validateDelRef(ut.getTableName(), id);
        ut.checkErrors();
        //
        deleteRole(id)
        ut.deleteRec(ut.getTableName(), id);
    }

    /**
     * Обновление пароля (из админки, не требуется старый пароль)
     */
    @DaoMethod
    public void updPasswd(DataRecord data) throws Exception {
        validatePassword(data);
        ut.checkErrors();
        //
        ut.updateRec(ut.getTableName(), [id: data.getValueLong("id"), passwd: UtString.md5Str(data.getValueString("passwd"))]);
    }

    //////

    @DaoMethod
    DataRecord loadRec(long id) {
        DataRecord t = ut.createRecord("AuthUser.edit");
        ut.loadSqlRec(t, "select * from ${ut.tableName} where id=:id", id);
        t.setValue("passwd", "")
        return t;
    }


    /**
     * Грузит дерево ролей с галочками для пользователя
     */
    @DaoMethod
    public DataStore loadRoles(Map params) throws Exception {

        long userId = params["userId"]

        String sOrderByName = OrderByUtils.getOrderByLangField("r.name", ut)

        SqlFilter f = ut.createSqlFilter("AuthRole", [:]);
        def sf = new SelectFieldUtils(ut)
        sf.addDomain("authrole", "r")
        f.sql = """
            select ${sf} from authrole r
            where r.id not in (select ru.authrole from authroleuser ru where ru.authuser = ${userId})
            order by ${sOrderByName}
        """

        DataStore res = ut.createStore("AuthRole");
        f.load(res)
        return res
    }

    /**
     * Грузит дерево ролей с галочками для пользователя
     */
    @DaoMethod
    public DataStore loadUserRoles(Map params) throws Exception {

        long userId = params["userId"]

        SqlFilter f = ut.createSqlFilter("AuthRole", [:]);
        def sf = new SelectFieldUtils(ut)
        sf.addDomain("authrole", "r")
        f.sql = """
            select ${sf} from authroleuser ru, authrole r
            where ru.authuser=${userId}
                and r.id=ru.authrole
            order by ru.id
        """

        DataStore res = ut.createStore("AuthRole");
        f.load(res)
        return res
    }

    /**
     * Создание новой пустой записи
     *
     * @return
     * @throws Exception
     */
    @DaoMethod
    public DataRecord newRec() throws Exception {
        return ut.createRecord();
    }


    @DaoMethod
    public long insTeacher(DataRecord record){
        record.setValue("authUserRole", FD_Const.AuthUserRole_teaching);
        record.setValue("authUserType", FD_Const.AuthUserType_user);
        record.setValue("parent", 1001);

        long id = ins(record);

        setRole(id, 1001);

        return  id;
    }

    @DaoMethod
    public long insStudent(DataRecord record){
        record.setValue("authUserRole", FD_Const.AuthUserRole_learned);
        record.setValue("authUserType", FD_Const.AuthUserType_user);
        record.setValue("parent", 1002);

        long id = ins(record);

        setRole(id, 1002);

        return  id;
    }

    private void setRole(long userId, int roleId) {
        DataStore ds = ut.createStore("AuthRole");
        ds.add(ut.loadRec("AuthRole", roleId))
        ut.daoinvoke("AuthRoleUser/updater","doUpdate", userId, ds);
    }
}
