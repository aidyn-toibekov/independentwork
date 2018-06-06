<%@ page import="exp.main.model.sys.*; jandcode.dbm.dao.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>

<gf:attr name="recId" type="long" ext="true"/>

<gf:groovy>
  <%
    GfFrame gf = args.gf
    GfAttrs a = gf.attrs
    //
    SGridDataStore st = gf.createSGridStore("AuthUser/updater")
    st.setDaoMethodLoad("loadUserRoles")
    st.load(userId: a.recId)

    a.store = st


  %>
</gf:groovy>

<g:javascript>
  th.nopadding = true;
  th.layout = b.layout('vbox');
  //
  var grid = b.sgrid({
    flex: 1,
    //
    store: th.store,


    columns: function(b) {
      return [
        b.column('name', {tdCls: "td-wrap", flex: 1}),
        b.column('fullName', {tdCls: "td-wrap", flex: 2})
      ];
    },

    actions: Jc.tofi.auth.actionList(
      b.action({text: "Редактировать список", icon: "upd", target: "edit:webmod-userrole", onExec: function(a) {
        Jc.showFrame({frame:"js/platform/usr/authuser/authUser_rolesRec.gf", userId: th.recId, onOk: function(){
          grid.reload()
        }})
      }})
    )

  });

  th.items = [
    grid
  ];
</g:javascript>