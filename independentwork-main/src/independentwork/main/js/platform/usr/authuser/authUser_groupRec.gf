<%@ page import="jandcode.utils.UtLang; jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>

<jc:include url="js/frame/edit_rec.gf"/>
<gf:attr name="daoname" value="AuthUser/updater"/>

<g:javascript>
    th.layout = b.layout('table', {colspan: 2});
    th.shower = "dialog";
    th.width = 520;  //fix width memo

    th.items = [
        [b.label(null, {text: UtLang.t("Наименование группы")}), th.i1 = b.input("name")],
        [b.label(null, {text: UtLang.t("Полное наименование группы")}), th.i2 = b.input("fullName")]
    ];
    Jc.tofi.syncInputLangstring(th.i1, th.i2);
    //
</g:javascript>

