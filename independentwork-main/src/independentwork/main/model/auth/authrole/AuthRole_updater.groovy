package independentwork.main.model.auth.authrole

import independentwork.main.model.auth.RoleImplEx
import independentwork.main.model.sys.AppUpdaterDao
import jandcode.auth.*
import jandcode.dbm.dao.*
import jandcode.dbm.data.*
import jandcode.utils.*

class AuthRole_updater extends AppUpdaterDao {

    @DaoMethod
    IRole getRole(long roleId) {
        DataRecord r = loadRec(roleId)
        RoleImplEx role = new RoleImplEx(ut.getModel().getDblangService())
        role.setName(UtCnv.toString(r.getValueLong("id")))
        role.setLangName(r, "name")
        role.setLangFullName(r, "fullName")

        DataStore rolePrivs = ut.loadSql("select * from AuthRolePriv where authrole=:roleId", [roleId: roleId])
        for (priv in rolePrivs) {
            role.addRolePriv(priv.getValueString("permis"), priv.getValueLong("busProcessBefore"), priv.getValueLong("busProcessAfter"))
        }

        return role
    }

    protected void onBeforeSave(DataRecord rec, boolean ins) {
        super.onBeforeSave(rec, ins);
        //   AuthRole_updater.checkNameNotVer(rec, ut)
    }

    protected void onBeforeDel(long id) {
        DataStore ds = ut.loadSql("select * from AuthRolePriv t where t.authRole=:id", [id: id])
        if (ds.size() > 0) {
            ut.errors.addErrorFatal(UtLang.t("Нельзя удалить роль пользователя, так как для нее определены привилегии"))
        } else {
            ds = ut.loadSql("select authUser as id from AuthRoleUser t where t.authRole=:id", [id: id])
            if (ds.size() > 0) {
                String errorText = errorText(ds, "AuthUser", "login")
                ut.errors.addErrorFatal(errorText)
            }
        }
    }

    protected String errorText(DataStore ds, String tName, String fld) {
        String text = ""
        for (DataRecord rec : ds) {
            DataRecord dr = ut.loadRec(tName, rec.getValueLong("id"))
            text += ", " + dr.getValueString(fld)
        }
        text = text.substring(1)
        text = ":" + text
        String errText

        errText = UtLang.t("Нельзя удалить роль, так как данная роль присвоена")
        if (ds.size() == 1)
            errText += " " + UtLang.t("следующему пользователю") + text
        else
            errText += " " + UtLang.t("следующим пользователям") + text
        return errText
    }
}
