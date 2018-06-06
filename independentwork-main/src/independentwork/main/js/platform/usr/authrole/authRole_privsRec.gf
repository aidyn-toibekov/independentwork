<%@ page import="jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>

<jc:include url="js/platform/usr/authrole/authPrivs_recTree.gf"/>
<gf:attr name="daoname" value="AuthRolePriv/updater"/>
<gf:attr name="daomethod" value="doUpdate"/>
<gf:attr name="privdaoname" value="AuthRole/priv"/>

<g:javascript>
  th.title = UtLang.t("Редактирование привилегий");
  th.nopadding = true;
</g:javascript>

<g:javascript id="onOk" method="onOk">
  th.onBeforeOk();
  th.controlToData();
  return  Jc.daoinvoke(th.daoname, th.daomethod, [th.recId, th.arr]);
</g:javascript>