<%@ page import="jandcode.dbm.dao.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--

Список пользователей

========================================================================= --}%
<gf:groovy>
  <%
    GfFrame gf = args.gf
    Map a = gf.attrs
    //
    STreeDataStore st = gf.createSTreeStore("AuthUser/tree")
    st.load(node: 0)

    a.store = st

    //todo изменить на значение FD_AuthUserType_User
    a.authUserType_User = 2

  %>
</gf:groovy>

<g:javascript>
  //
  th.title = UtLang.t('Пользователи');
  th.layout = b.layout('vbox');
  //
  var sgrid = b.stree({
    flex: 1,
    //
    store: th.store,
    refreshRec: true,
    //
    orderBy: [
      {name: "name", title: UtLang.t("По наименованию")},
      {name: "fullName", title: UtLang.t("По полному наименованию")}
    ],
    //
    columns: function(b) {
      return [
        b.column("name", {jsclass: "TreeLangstring", tdCls: "td-wrap", flex: 2}),
        b.column("fullName", {tdCls: "td-wrap", flex: 3}),
        b.column("login", {flex: 1}),
        b.column("authUserRole", {flex: 1}),
        b.column("phoneNumber", {flex: 1})
      ];
    },
    //
    actions: Jc.tofi.auth.actionList(
        b.action({
          mode: 'ins',
          icon: "ins",
          text: 'Добавить',
          target: "add:webmod-user",
          menu: [
            th.createGroup(b),
            th.createSubGroup(b),
            th.createUser(b)
          ]
        }),
        //b.actionInsFrame({frame: 'Jc.auth.AuthUser_rec', text: UtLang.t("Создать")}),
        b.actionUpdFrame({disabled: true, itemId: "UPD", target: "update:webmod-user",
          onExec: function(a) {
            if (!a.recData) {
              a.recData = {};
            }
            if (a.onBeforeShow) {
              a.onBeforeShow(a);
            }
            if (a.rec.get("authUserType") == 1) {
              a.frame = 'js/platform/usr/authuser/authUser_groupRec.gf';
            } else {
              a.frame = 'js/platform/usr/authuser/authUser_rec.gf';
            }
            Jc.showFrame({frame: a.frame, recId: a.recId, recData: a.recData, onOk: function(fr) {
              a.grid.updRec(fr.store);
            }});
          }}),
        b.actionUpdFrame({frame: 'Jc.auth.ChangePassword', text: UtLang.t('Изменить пароль'), icon: 'key', disabled: true, itemId: "PWD", target: "update:webmod-user"}),
        b.actionDelFrame({daoname: 'AuthUser/updater', disabled: true, itemId: "DEL", target: "delete:webmod-user"}),
        b.actionViewFrame({frame: 'js/platform/usr/authuser/authUser_view.gf', text: UtLang.t('Выбрать'), icon: 'choice', disabled: true, itemId: 'view',
          onExec: function(a) {
            if (a.rec.get("authUserType") == th.authUserType_User)
              Jc.showFrame({frame: a.frame, recId: a.recId, id: a.frame, replace: true});
          }
        })
    )
  });

  sgrid.on("select", function(gr, rec) {
    if (!rec) return;

    Jc.getComponent(th, 'UPD').enable();
    Jc.getComponent(th, 'DEL').enable();

    if (rec.get("authUserType") == 2) {
      Jc.getComponent(th, 'PWD').enable();
      Jc.getComponent(th, 'view').enable();
      Jc.getComponent(th, 'INSG').disable();

      var p = rec.parentNode;
      if (p.get("id") != 0) {
        Jc.getComponent(th, 'INSU').enable();
      } else {
        Jc.getComponent(th, 'INSU').disable();
      }
    } else {
      Jc.getComponent(th, 'PWD').disable();
      Jc.getComponent(th, 'view').disable();
      Jc.getComponent(th, 'INSU').enable();
      Jc.getComponent(th, 'INSG').enable();
    }
  });

  th.store.on('remove', function() {
    Jc.getComponent(th, 'UPD').disable();
    Jc.getComponent(th, 'PWD').enable();
    Jc.getComponent(th, 'DEL').disable();
    Jc.getComponent(th, 'view').disable();
  });

  //
  th.items = [
    b.frameheader({icon: "user"}),
    sgrid
  ];
</g:javascript>

<g:javascript method="createUser" params="b">
  var recFrame = 'js/platform/usr/authuser/authUser_rec.gf';
  var daoUpdater = 'AuthUser/updater';

  var act = b.actionRec({
    mode: 'ins',
    icon: "user",
    text: UtLang.t("Пользователя"),
    frame: recFrame,
    itemId: "INSU",
    disabled: true,
    onExec: function(a) {

      if (!a.recData) {
        a.recData = {};
      }

      var sgrid = a.grid;

      var cr = sgrid.getCurRec();
      var par = cr

      if (cr.get("authUserType") == 2) {
        par = cr.parentNode;
      }

      a.recData["parent"] = par.get("id");
      a.recData["authUserType"] = 2;

      Jc.showFrame({frame: recFrame, recData: a.recData, onOk: function(fr) {
        sgrid.insRec(fr.store, par);
      }});
    }
  })
  //
  return act;

</g:javascript>

<g:javascript method="createGroup" params="b">
  var recFrame = 'js/platform/usr/authuser/authUser_groupRec.gf';
  var daoUpdater = 'AuthUser/updater';

  var act = b.actionInsFrame({
    mode: 'ins',
    icon: "ins",
    text: UtLang.t("Группу"),
    frame: recFrame,
    onExec: function(a) {

      if (!a.recData) {
        a.recData = {};
      }

      var sgrid = a.grid;

      var cr = sgrid.getCurRec();

      a.recData["parent"] = null;
      a.recData["authUserType"] = 1;

      if (cr) {
        var par = cr.parentNode;
        if (par.get('id') != 0) {
          a.recData["parent"] = par.get('id');
        }
      }
      Jc.showFrame({frame: recFrame, recData: a.recData, onOk: function(fr) {
        sgrid.insRec(fr.store, par);
      }});
    }
  })
  //
  return act;

</g:javascript>

<g:javascript method="createSubGroup" params="b">
  var recFrame = 'js/platform/usr/authuser/authUser_groupRec.gf';
  var daoUpdater = 'AuthUser/updater';

  var act = b.actionRec({
    mode: 'ins',
    icon: "ins",
    text: UtLang.t("Подгруппу"),
    frame: recFrame,
    itemId: "INSG",
    disabled: true,
    onExec: function(a) {

      if (!a.recData) {
        a.recData = {};
      }

      var sgrid = a.grid;

      var cr = sgrid.getCurRec();

      if (cr.get("authUserType") != 1) {
        return
      }

      a.recData["parent"] = cr.get("id");
      a.recData["authUserType"] = 1;

      Jc.showFrame({frame: recFrame, recData: a.recData, onOk: function(fr) {
        sgrid.insRec(fr.store, cr);
      }});
    }
  })
  //
  return act;

</g:javascript>
