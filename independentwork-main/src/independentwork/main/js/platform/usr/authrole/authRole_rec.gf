<%@ page import="jandcode.utils.UtLang; jandcode.wax.core.utils.gf.GfFrame; jandcode.dbm.data.DataRecord" %>

<jc:include url="js/frame/edit_rec.gf"/>

<gf:attr name="daoname" value="AuthRole/updater"/>


<g:javascript>
  th.width = 520;
  th.items = [
    th.i1 = b.input2("name"),
    th.i2 = b.input2("fullName"),
    b.delim(UtLang.t("Комментарий")),
    b.input("cmt", {colspan: 2, width: "100%"})
  ];
  Jc.tofi.syncInputLangstring(th.i1[1], th.i2[1]);
</g:javascript>


