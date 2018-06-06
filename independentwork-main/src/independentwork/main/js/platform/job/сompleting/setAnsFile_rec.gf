<%@ page import="jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>


<gf:attr name="recData" type="map" ext="true"/>
<gf:groovy>
  <%
    GfFrame gf = args.gf
    def a = gf.attrs

    // грузим запись
    DataRecord rec = gf.daoinvoke("JobExecutor/updater", "newRec")
    a.store = rec

    // данные по умолчанию с клиента
    Map recData = a.recData
    if (recData.size() > 0) {
      rec.setValues(recData)
      gf.resolveDicts(rec)
    }

  %>
</gf:groovy>

%{-- ========================================================================= --}%
<g:javascript>
    th.title=UtLang.t("Файл ответ на задание")
    th.width = 500;

    th.layout = b.layout('table', {columns: 2});
    th.shower = "dialog";
    //
    th.items = [
        b.input2("fn",{flex:1})
    ];
</g:javascript>

<g:javascript id="onOk" method="onOk">
  th.controlToData();
  Jc.daoinvoke("JobExecutor/updater", "setAnswerFile", [th.store]);
</g:javascript>
