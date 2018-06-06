<%@ page import="jandcode.wax.core.utils.*; jandcode.dbm.data.*; jandcode.dbm.*; jandcode.web.*" %>
<script type="text/javascript">
  <%
    WaxTml th = new WaxTml(this)
  %>
  /**
   *
   */
  Ext.define('Jc.auth.AuthRole_rec', {
    extend: 'Jc.frame.EditRec',

    domain: "AuthRole.edit",
    daoname: "AuthRole/updater",

    onCreateControls: function(b) {
      var th = this;
      //
      var treeStore = Jc.createTreeStore("AuthRole.privtree", {
        daoname: 'AuthRole/priv',
        daomethod: 'loadForRole',
        daoparams: [th.recId]
      });
      var tree = th.tree = b.tree({
        colspan: 2,
        store: treeStore,
        height: 300
      });
      /*tree.on("checkchange", function(node, checked) {
        if (checked) {
          var parent = node.parentNode;
          if (!parent.isRoot() && !parent.get("checked")) {
            parent.set("checked", true);
          }
        } else {
          node.childNodes.forEach(function(child) {
            if (child.get(checked)) {
              child.set("checked", false);
            }
          })
        }
      });*/
      //
      this.items = [
        b.input2("code"),
        b.input2("name"),
        b.delim(UtLang.t("Привилегии роли")),
        tree
      ];
      //

    },

    saveData: function() {
      var records = this.tree.getView().getChecked();
      var ids = [];
      Ext.Array.each(records, function(rec) {
        ids.push(rec.get('id'));
      });
      this.store.getCurRec().set("privs", ids.join(','));
      //
      this.callParent();
    }

  });

</script>
