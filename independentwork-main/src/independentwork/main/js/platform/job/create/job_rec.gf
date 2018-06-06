<%@ page import="jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--

Редактор для записи

========================================================================= --}%


<jc:include url="js/frame/edit_rec.gf"/>
<gf:attr name="daoname" value="Job/updater"/>

%{-- ========================================================================= --}%
<g:javascript>
  th.width = 700;
  //
  th.items = [
    b.input2("name", {width:600}),
    b.input2("dte"),
    b.delim(UtLang.t("Описание")),
    b.input("description", {colspan: 2, width: "90%"}),
    b.input2("subject",{jsclass: "Cb_Subject"}),
    b.input2("fn"),
    b.delim(UtLang.t("Комментарий")),
    b.input("cmt", {colspan: 2, width: "90%"})
  ];


</g:javascript>
