<%@ page import="jandcode.wax.core.utils.*; jandcode.dbm.data.*; jandcode.dbm.*; jandcode.web.*" %>
<script type="text/javascript">
  <%
    WaxTml th = new WaxTml(this)
  %>
  /**
   *
   */
  Ext.define('Jc.auth.AuthUser_rec', {
    extend: 'Jc.frame.EditRec',

    domain: "AuthUser.edit",
    daoname: "AuthUser/updater",

    onCreateControls: function(b) {
      var th = this;
      th.items = [
        b.delim(UtLang.t("Основные свойства")),
        b.input2("name"),
        b.input2("fullName"),
        b.input2("locked")
      ];

      //
      if (th.mode == "ins") {
        th.items.push([
          b.delim(UtLang.t("Пароль")),
          b.input2("passwd"),
          b.input2("passwd2")
        ]);
      }

      //
      var treeStore = Jc.createTreeStore("AuthUser.roletree", {
        daoname: 'AuthUser/updater',
        daomethod: 'loadRoles',
        daoparams: [th.recId]
      });
      var tree = th.tree = b.tree({
        colspan: 2,
        store: treeStore,
        height: 200
      });

      //
      th.items.push(
          b.delim(UtLang.t("Роли пользователя")),
          tree
      )

    },

    saveData: function() {
      var records = this.tree.getView().getChecked();
      var ids = [];
      Ext.Array.each(records, function(rec) {
        ids.push(rec.get('id'));
      });
      this.store.getCurRec().set("roles", ids.join(','));
      //
      this.callParent();
    }

  });

</script>
