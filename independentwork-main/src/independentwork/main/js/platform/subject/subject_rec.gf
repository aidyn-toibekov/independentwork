<%@ page import="jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--

Редактор для записи

========================================================================= --}%


<jc:include url="js/frame/edit_rec.gf"/>
<gf:attr name="daoname" value="Subject/updater"/>

%{-- ========================================================================= --}%
<g:javascript>
    th.width = 500;
    //
    th.items = [
        th.i1 = b.input2("name"),
        th.i2 = b.input2("fullName"),
        b.delim(UtLang.t("Комментарий")),
        b.input("cmt", {colspan: 2, width: "100%"})
    ];
    //
    Jc.tofi.syncInputLangstring(th.i1[1], th.i2[1]);
    //
</g:javascript>
