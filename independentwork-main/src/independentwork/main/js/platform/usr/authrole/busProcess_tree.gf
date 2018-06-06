<%@ page import="jandcode.utils.UtDate; exp.main.model.sys.*; jandcode.dbm.dao.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>

<gf:attr name="busProcess" type="long" ext="true"/>

<gf:groovy>
  <%
    GfFrame gf = args.gf
    GfAttrs a = gf.attrs
    //
    STreeDataStore st = gf.createSTreeStore("BusProcess/tree")
    st.load(node: 0, checkId: a.busProcess)

    a.store = st
    a.busProcessType_group = FD_Const.BusProcessType_group;
  %>
</gf:groovy>

<g:javascript>
  th.title = UtLang.t('Выбрать бизнес-процесс');
  th.layout = b.layout('fit');
  th.nopadding = true;
  th.shower = 'dialog';
  th.width = 400;
  th.height = 200;
  //

  //конфигурация дерева
  var cfg = {
    flex: 1,
    //
    store: th.store,
    //
    columns: function(b) {
      return [
        b.column('name', {jsclass: "Tree", tdCls: "td-wrap", flex: 1}),
        b.column('busProcessType', {flex: 1})
      ];
    }
  }

  //
  th.grid = b.stree(cfg);
  th.grid.expandAll();

  th.grid.on("checkchange", function(node, checked) {
    if (!checked) {
      th.busProcess = 0;
      return;
    }

    th.grid.getChecked().forEach(function(n) {
      if (node != n) {
        n.set("checked", false);
      }
    });
    if (node.get("busProcessType") != th.busProcessType_group) {
      th.busProcess = node.get("id");
    }
  });

  th.items = [
    th.grid
  ];
</g:javascript>
