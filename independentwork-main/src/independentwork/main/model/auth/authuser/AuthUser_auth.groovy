package independentwork.main.model.auth.authuser

import independentwork.main.model.auth.RoleImplEx
import independentwork.main.model.auth.UserInfoImplEx
import jandcode.auth.*
import jandcode.dbm.dao.*
import jandcode.dbm.data.*
import jandcode.utils.*
import jandcode.utils.error.*
import jandcode.wax.core.model.*

/**
 * Аутенфикация
 */
public class AuthUser_auth extends WaxDao {

    /**
     * login
     * @param username имя пользователя
     * @param passwd пароль
     * @return информация о пользователе или ошибка
     */
    @DaoMethod
    public IUserInfo login(String login, String passwd) throws Exception {
        passwd = UtString.md5Str(passwd)
        login = login.toLowerCase()
        def lst = ut.createStore()
        ut.loadSql(lst,
                "select * from ${ut.tableName} where LOWER(login)=:login and passwd=:passwd",
                [login: login, passwd: passwd]
        )
        if (lst.size() == 0) {
            throw new XError(UtLang.t("Логин пользователя или пароль неправильные"));
        }
        //
        def t = lst.getCurRec()
        if (t.getValueBoolean("locked")) {
            throw new XError(UtLang.t("Пользователь заблокирован"));
        }
        //
        checkUserPriv(t)
        //
        return loadUserInfoForRec(t)
    }

    /**
     * Создать и загрузить IUserInfo по записи пользователя
     * @param t
     * @return
     */
    public IUserInfo loadUserInfoForRec(DataRecord t) {
        //
        UserInfoImplEx ui = new UserInfoImplEx(app.service(AuthService), ut.getModel().getDblangService());
        ui.setId(t.getValueLong("id"));
        ui.setName(t.getValueString("login"));
        //ui.setFullname(t.getValueString("fullName"));
        ui.setLangName(t, "name")
        ui.setLangFullName(t, "fullName")
        ui.setGuest(false);
        ui.setLocked(t.getValueBoolean("locked"));
        ui.getAttrs().put("email", t.getValueString("email"))
        ui.getAttrs().put("phoneNumber", t.getValueString("phoneNumber"))
        // роли пользователя
        DataStore roles = ut.loadSql("""
            select r.id from AuthRoleUser ru, AuthRole r
            where r.id=ru.authRole and ru.authUser=:id
            order by ord
        """, ui.getId())
        List<String> roleIds = new ArrayList<String>()
        for(DataRecord roleRec : roles){
            roleIds.add(UtCnv.toString(roleRec.getValueLong("id")))
        }
        ui.updateRoles(roleIds)
        // привелегии пользователя
        DataStore privsStore = ut.loadSql("""
            select p.permis, p.busprocessbefore, p.busprocessafter from AuthUserPriv p
            where p.authUser=:id
        """, ui.getId())
        for (DataRecord record : privsStore) {
            ui.addUserPriv(record.getValueString("permis"), record.getValueLong("busprocessbefore"), record.getValueLong("busprocessafter"))
        }
        //
        return ui;
    }

    @DaoMethod
    public IUserInfo getUserInfo(long userId) {
        def r = ut.loadRec("AuthUser", userId);
        return loadUserInfoForRec(r)
    }

    /**
     * Загрузка всех ролей с привелегиями из базы
     */
    @DaoMethod
    public Collection<IRole> loadAllRoles() {
        DataStore roles = ut.loadSql("select * from AuthRole")
        DataStore rolePrivs = ut.loadSql("select * from AuthRolePriv")
        def m_role = [:]
        for (role in roles) {
            RoleImplEx ri = new RoleImplEx(ut.getModel().getDblangService())
            ri.setName(UtCnv.toString(role.getValueLong("id")))
            //ri.setTitle(role.getValueString("name_ru"))
            ri.setLangName(role, "name")
            ri.setLangFullName(role, "fullName")
            m_role[role.getValueLong("id")] = ri
        }
        for (priv in rolePrivs) {
            def rid = priv.getValueLong("authRole")
            RoleImplEx roleInst = m_role.get(rid)
            if (roleInst != null) {
                roleInst.addRolePriv(priv.getValueString("permis"), priv.getValueLong("busProcessBefore"), priv.getValueLong("busProcessAfter"))
            }
        }
        return m_role.values()
    }

    /**
     * Проверка доступа пользователя к приложению
     */
    public void checkUserPriv(DataRecord t) {

    }
}
