<%@ page import="jandcode.wax.core.utils.*; jandcode.dbm.data.*; jandcode.dbm.*; jandcode.web.*" %>
<script type="text/javascript">
  <%
    WaxTml th = new WaxTml(this)

  %>
  /**
   *
   */
  Ext.define('Jc.auth.AuthUser_list', {
    extend: 'Jc.Frame',

    onInit: function() {
      this.callParent();
      var th = this;
      var b = th.createBuilder();

      //
      Ext.apply(th, {
        title: UtLang.t('Пользователи'),
        layout: b.layout('vbox')
      });

      //
      var sgrid;
      th.items = [
        b.frameheader({icon: "user"}),
        //
        sgrid = b.create('Jc.control.SGrid', {
          flex: 1,
          //
          domain: "AuthUser.list",
          daoname: "AuthUser/list",
          refreshRec: true,
          paginate: true,
          //
          filterPanel: true,
          filterDomain: "AuthUser.filter",
          filterFrame: function(b) {
            return [
              b.input2("name"),
              b.input2("fullName"),
              b.input2("locked")
            ];
          },
          //
          orderBy: [
            {name: "id", title: UtLang.t("По ID")},
            {name: "name", title: UtLang.t("По имени")},
            {name: "fullName", title: UtLang.t("По полному имени")}
          ],
          //
          columns: function(b) {
            return [
              b.column("id"),

              b.column("name", {jsclass: "Icontext", atag: true,
                onIconCell: function(v, m, r) {
                  if (r.get("locked")) {
                    return "cancel";
                  } else {
                    return "user";
                  }
                },
                onTextCell: function(v, m, r) {
                  return '<b>' + v + '</b>';
                },
                onClickCell: function(rec, e) {
                  if (e.getTarget('a')) {
                    Jc.execAction(sgrid, 'view');
                  }
                }
              }),

              b.column("fullName", {flex: 1})
            ];
          },
          //
          actions: function(b) {
            return [
              b.actionInsFrame({frame: 'Jc.auth.AuthUser_rec'}),
              b.actionUpdFrame({frame: 'Jc.auth.AuthUser_rec'}),
              b.actionUpdFrame({frame: 'Jc.auth.ChangePassword', text: UtLang.t('Изменить пароль'), icon: 'key'}),
              b.actionDelFrame({daoname: 'AuthUser/updater'}),
              b.actionRec({text: UtLang.t('Профиль'), icon: 'show', itemId: 'view', onExec: function(a) {
                Jc.showFrame({frame: 'js/auth/userProfile.html', params: {id: a.recId}});
              }})
            ]
          }
        })
      ];

    }

  });


</script>
