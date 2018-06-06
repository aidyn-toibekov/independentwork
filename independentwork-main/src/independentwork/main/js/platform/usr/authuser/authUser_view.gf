<%@ page import="independentwork.main.model.auth.UserInfoImplEx; jandcode.auth.IUserInfo; jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
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
    UserInfoImplEx userInfo = gf.daoinvoke("AuthUser/auth", "getUserInfo", a.recId)
    def roleNames = []
    def privNames = []
    for (r in userInfo.roles) {
      roleNames.add(r.title)
    }
    for (r in userInfo.privs) {
      privNames.add(r.title)
    }

    a.userInfo = [cod: userInfo.name, name: userInfo.shortname, fullname: userInfo.fullname, locked: userInfo.locked, email: userInfo.attrs.get("email"), phoneNumber: userInfo.attrs.get("phoneNumber"), roleNames: roleNames, privNames: privNames]
  %>
</gf:groovy>

%{-- ========================================================================= --}%
<g:javascript>
  //
  th.title = UtLang.t('Пользователь');
  th.layout = b.layout('vbox');

  //
  var tabpanelItems = [];
  tabpanelItems.push(th.createInfoPanel(b));
  tabpanelItems.push(th.createRolePanel(b));
  tabpanelItems.push(th.createPrivPanel(b));
  tabpanelItems = Jc.tofi.auth.tabpanelItemList(tabpanelItems);
  //
  //Объект th.role обделяем методом get, который возвращает соответсвующее свойство объекта
  th.userInfo.get = function(a) {
    return this[a];
  }
  th.items = [
    b.pageheader(Jc.tofi.pageheaderEntityText(th.userInfo), 'user'),
    b.tabpanel({flex: 1, plain: true, activeTab: tabpanelItems[th.activeTab], items: tabpanelItems})
  ]
</g:javascript>

%{-- ========================================================================= --}%
<g:javascript method="createInfoPanel" params="b">
  var items = [
    b.label(UtLang.t("Имя")),
    b.datalabel(th.userInfo.name, {jsclass: "String"}),
    b.label(UtLang.t("Полное имя")),
    b.datalabel(th.userInfo.fullname, {jsclass: "String"}),
    b.label(UtLang.t("Заблокирован")),
    b.datalabel(th.userInfo.locked, {jsclass: "Boolean"}),
    b.label(UtLang.t("Электронная почта")),
    b.datalabel(th.userInfo.email, {jsclass: "String"}),
    b.label(UtLang.t("Телефон")),
    b.datalabel(th.userInfo.phoneNumber, {jsclass: "String"}),
    b.delim(UtLang.t("Информация о правах")),
    b.label(UtLang.t("Роли")),
    b.datalabel(th.userInfo.roleNames.join(", "), {jsclass: "String"}),
    b.label(UtLang.t("Привилегии")),
    b.datalabel(th.userInfo.privNames.join(", "), {jsclass: "String"})
  ];

  var actions = Jc.tofi.auth.actionList(
      b.actionUpd({target: "update:webmod-user", onExec: function() {
        Jc.showFrame({frame: 'js/platform/usr/authuser/authUser_rec.gf', recId: th.recId, onOk: function() {
          th.reload();
        }})
      }}),
      b.action({text: UtLang.t('Изменить пароль'), icon: 'key', target: "update:webmod-user", onExec: function() {
        Jc.showFrame({frame: 'Jc.auth.ChangePassword', recId: th.recId});
      }}),
      th.getActionDel("AuthUser/updater", th.recId, "js/platform/usr/authuser/authUser_list.gf", "", {target: "delete:webmod-user"})
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
<g:javascript method="createRolePanel" params="b">
  return b.gfpanel({
    title: UtLang.t('Роли пользователя'),
    frame: {frame: 'js/platform/usr/authuser/authUser_roles.gf', recId: th.recId},
    target: "webmod-userrole"
  });
</g:javascript>

<g:javascript method="createPrivPanel" params="b">
  return b.gfpanel({
    title: UtLang.t('Привилегии пользователя'),
    frame: {frame: 'js/platform/usr/authuser/authUser_privs.gf', recId: th.recId},
    target: "webmod-userpriv"
  });
</g:javascript>
