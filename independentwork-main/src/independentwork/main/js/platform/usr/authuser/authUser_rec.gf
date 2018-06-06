<%@ page import="independentwork.main.model.sys.FD_Const; jandcode.utils.UtLang; jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>

<jc:include url="js/frame/edit_rec.gf"/>
<gf:attr name="daoname" value="AuthUser/updater" />

<gf:groovy>
    <%
        GfFrame gf = args.gf
        Map a = gf.attrs
        //
       a.userRoleUndefined = FD_Const.AuthUserRole_undefined;

        if(a.mode == "ins" && a.store.get("authUserRole")==0){
            a.store.set("authUserRole",a.userRoleUndefined)
        }
    %>
</gf:groovy>

<g:javascript>
    th.layout = b.layout('table', {colspan: 2});
    th.shower = "dialog";
    th.width = 520;

    th.items = [
        b.input2("login"),
        th.i1 = b.input2("name"),
        th.i2 = b.input2("fullName"),
        b.input2("authUserRole"),
        b.input2("locked")
    ];
    //
    if (th.mode == "ins") {
        th.items.push([
            b.delim(UtLang.t("Пароль")),
            b.input2("passwd"),
            b.input2("passwd2")
        ]);
    }
    th.items.push([
        b.delim(UtLang.t("Контактные данные")),
        b.input2("email", {width: "medium"}),
        b.input2("phoneNumber", {width: "medium"})
    ])

    Jc.tofi.syncInputLangstring(th.i1[1], th.i2[1]);

</g:javascript>