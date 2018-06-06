<%@ page import="independentwork.main.model.auth.RoleImplEx; jandcode.auth.IPriv; jandcode.auth.AuthService; jandcode.auth.IUserInfo; jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--

Просмотр пользователя

========================================================================= --}%
<jc:include url="js/frame/view_actions.gf"/>
<gf:attr name="recId" type="long" ext="true"/>

<gf:groovy>
  <%
    GfFrame gf = args.gf
    GfAttrs a = gf.attrs
    //
    RoleImplEx role = gf.daoinvoke("AuthRole/updater", "getRole", a.recId)
    def privNames = []
    for (IPriv priv in role.getPrivs(gf.getApp().service(AuthService.class))) {
      privNames.add(priv.title)
    }

    a.role = [cod: role.name, name: role.title, fullname: role.fullname, privNames: privNames]
  %>
</gf:groovy>

%{-- ========================================================================= --}%
<g:javascript>
  //
  th.title = UtLang.t('Роль');
  th.layout = b.layout('vbox');

  //
  var tabpanelItems = [];
  tabpanelItems.push(th.createInfoPanel(b));
  tabpanelItems.push(th.createPrivPanel(b));
  tabpanelItems = Jc.tofi.auth.tabpanelItemList(tabpanelItems);
  //

  //Объект th.role обделяем методом get, который возвращает соответсвующее свойство объекта
  th.role.get = function(a) {
    return this[a];
  }
  th.items = [
    b.pageheader(Jc.tofi.pageheaderEntityText(th.role), 'user'),
    b.tabpanel({flex: 1, plain: true, activeTab: tabpanelItems[th.activeTab], items: tabpanelItems})
  ]
</g:javascript>

%{-- ========================================================================= --}%
<g:javascript method="createInfoPanel" params="b">
  var items = [
    b.label(UtLang.t("Краткое наименование")),
    b.datalabel(th.role.name, {jsclass: "String"}),
    b.label(UtLang.t("Полное наименование")),
    b.datalabel(th.role.fullname, {jsclass: "String"}),
    b.label(UtLang.t("Привилегии")),
    b.datalabel(th.role.privNames.join(", "), {jsclass: "String"})
  ];

  var actions = Jc.tofi.auth.actionList(
      b.actionUpd({target: "update:webmod-role", onExec: function() {
        Jc.showFrame({frame: 'js/platform/usr/authrole/authRole_rec.gf', recId: th.recId, onOk: function() {
          th.reload();
        }})
      }}),

      th.getActionDel('AuthRole/updater', th.recId, "js/usr/authrole/authRole_list.gf", "", {target: "delete:webmod-role"})
  );

  return b.panel({
    items: items,
    title: UtLang.t('Описание'),
    layout: b.layout('table'),
    autoScroll: true,
    bodyPadding: 8,
    tbar: actions
  });
</g:javascript>

%{-- ========================================================================= --}%
<g:javascript method="createPrivPanel" params="b">
  return b.gfpanel({
    title: UtLang.t('Привилегии роли'),
    frame: {frame: 'js/platform/usr/authrole/authRole_privs.gf', recId: th.recId},
    target: "webmod-rolepriv"
  });
</g:javascript>
