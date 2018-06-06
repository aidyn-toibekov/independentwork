<%@ page import="jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>

<gf:attr name="userId" type="long" ext="true"/>

<gf:groovy>

  <%
    GfFrame gf = vars.gf
    GfAttrs a = gf.attrs
    //
    SGridDataStore allRoles = gf.createSGridStore("AuthUser/updater")
    allRoles.setDaoMethodLoad("loadRoles")
    allRoles.load(userId: a.userId)

    a.allRoles = allRoles

    SGridDataStore userRoles = gf.createSGridStore("AuthUser/updater")
    userRoles.setDaoMethodLoad("loadUserRoles")
    userRoles.load(userId: a.userId)

    a.userRoles = userRoles

  %>

</gf:groovy>

%{-- ========================================================================= --}%
<g:javascript>
  th.title = UtLang.t('Изменить');
  th.layout = b.layout('border');
  th.shower = 'dialog';
  th.nopadding = true;
  th.width = 900;
  th.height = 500;

  var allRolesCfg = {
    title: UtLang.t("Доступные роли"),
    flex: 1,
    region: 'west',
    border: false,
    split: true,
    splitterBorder: true,
    store: th.allRoles,
    refreshRec: true,
    columns: function(b) {
      return [
        b.column('name', {tdCls: "td-wrap", flex: 1}),
        b.column('fullName', {tdCls: "td-wrap", flex: 2})
      ];
    },
    viewConfig: {
      itemId: "allRoles",
      plugins: {
        ptype: 'gridviewdragdrop',
        ddGroup: 'dd1'
      },
      listeners: {
        beforedrop: function(node, data) {
          if (data.view.itemId == "allRoles")
            return false;
        }
      }
    }
  };
  //
  var userRolesCfg = {
    title: UtLang.t('Роли пользователя'),
    store: th.userRoles,
    width: 400,
    region: 'center',
    flex: 1,
    //
    columns: function(b) {
      return [
        b.column('name', {tdCls: "td-wrap", flex: 1}),
        b.column('fullName', {tdCls: "td-wrap", flex: 2})
      ];
    },
    viewConfig: {
      itemId: "userRoles",
      plugins: {
        ptype: 'gridviewdragdrop',
        ddGroup: 'dd1'
      }
    }
  };
  //
  var allRolesGrid = b.sgrid(allRolesCfg),
      userRolesGrid = th.userRolesGrid = b.sgrid(userRolesCfg);

  th.items = [allRolesGrid, userRolesGrid]
</g:javascript>

%{-- ========================================================================= --}%
<g:javascript method="onOk">
  Jc.daoinvoke("AuthRoleUser/updater", "doUpdate", [th.userId, th.userRolesGrid.getStore()]);
</g:javascript>