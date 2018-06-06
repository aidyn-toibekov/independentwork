<%@ page import="jandcode.utils.*; jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{-- 


========================================================================= --}%

<gf:groovy>
  <%
    GfFrame gf = args.gf
    GfAttrs a = gf.attrs
    //
  %>
</gf:groovy>

%{-- ========================================================================= --}%
<g:javascript>
  //
  th.width = 420;
  th.shower = "dialogclose";
  th.title = UtLang.t("О программе...");
  th.layout = b.layout('vbox');
  //
      this.items = [
        b.pageheader("Самостоятельная работа обучаемого".bold(), Jc.url("page/logo.png")),
        b.box({
          layout : b.layout("vbox"),
          items: [
            b.datalabel("Автор:"),
            b.datalabel("Выпускник ЕНУ им Гумилева".bold()),
            b.datalabel("(c) Алпамыс Пентаев".bold()),
            b.datalabel("Астана - 2018".bold())
          ]
        })
      ];


</g:javascript>
