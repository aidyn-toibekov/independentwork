<%@ page import="jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{-- 

Фрейм предок для выбора из дерева

В потомке обычно перекрываем:

<g:javascript id="gridColumns">
</g:javascript>

<g:javascript id="gridOrderBy">
</g:javascript>

========================================================================= --}%

<gf:attr name="width" type="int" value="800"/>
<gf:attr name="daoname" type="string" value="NONE"/>
<gf:attr name="title" type="string" value=""/>

<gf:groovy id="loadData" method="loadData">
  <%
    GfFrame gf = args.gf
    GfAttrs a = gf.attrs
    //
    STreeDataStore st = gf.createSTreeStore(a.daoname)
    st.load(node: 0)

    a.store = st
  %>
</gf:groovy>

%{-- ========================================================================= --}%
<g:javascript>
  //
  th.layout = b.layout('fit');
  th.nopadding = true;
  //    th.width = 800;
  th.resizable = true;
  th.flex = 1;

  //
  var sgridCfg = {
    //
    flex: 1,
    store: th.store,
    border: false,
    //
    columns: function(b) {
      var res = [];
      th.gridColumns(b, res);
      return res;
    },
    //
    actions: function(b) {
      var res = [];
      var saveStore = b.store;
      b.store = th.store.filterStore;
      th.gridActions(b, res);
      b.store = saveStore;
      return res;
    }
  };

  //
  var orderByCfg = [];
  th.gridOrderBy(b, orderByCfg);
  if (orderByCfg.length > 0) {
    sgridCfg.orderBy = orderByCfg;
  }
  th.gridConfig(b, sgridCfg);
  var sgrid = b.stree(sgridCfg);
  //
  th.grid = sgrid;
  //
  th.items = [
    sgrid
  ];

  // enter на toolbar = find
  var tb = Jc.getComponent(sgrid, "mainToolbar");
  if (tb) {
    tb.on("render", function() {
      var m = new Ext.util.KeyMap(tb.el, {
        key: Ext.EventObject.ENTER,
        fn: function() {
          Jc.execAction(sgrid, "find");
        },
        scope: th
      });
    });
  }


  sgrid.on("afterrender", function() {
    var cb = th.pickerField;
    if (cb) {
      var val = cb.getValue();
      var cr = this.store.getNodeById(val);
      if (cr) {
        this.setCurRec(cr);
      }
    }
  });

  th.onCtrlOk();

</g:javascript>

%{-- =========================================================================

  Конфигурация колонок

--}%
<g:javascript id="gridColumns" method="gridColumns" params="b, res">
  res.push(
      b.column('name', {jsclass: 'TreeLangstring', tdCls: "td-wrap", flex: 1}),
      b.column('fullName', {tdCls: "td-wrap", flex: 2}),
      b.column('cod')
  );
</g:javascript>

%{-- =========================================================================

  Конфигурация actions

--}%
<g:javascript id="gridActions" method="gridActions" params="b, res">
  res.push(
      b.actionRec({text: 'Выбрать', icon: 'ok', itemId: 'view', onExec: function(a) {
        if (th.onBeforeChoce(a)) {
          th.choice(a.recId);
        }
      }}),
      '-'
  );
</g:javascript>

<g:javascript id="onBeforeChoce" method="onBeforeChoce" params="a">
  return true;
</g:javascript>

%{-- =========================================================================

Дополнительная конфигурация grid
для получения параметров из комбобокса для передачи фрейму
--}%
<g:javascript id="gridConfig" method="gridConfig" params="b, cfg">
  var th = this;
  var filterParams = {};

  if (th.pickerField) {
    filterParams = th.pickerField.filterParams;
  }

  var config = Ext.apply(cfg.store.daoparams[0], filterParams);

  th.gridConfigExt(b, config);

</g:javascript>

%{-- =========================================================================

Дополнительная конфигурация grid

--}%
<g:javascript method="gridConfigExt" params="b, cfg">

</g:javascript>


%{-- =========================================================================

  Конфигурация сортировки

--}%
<g:javascript id="gridOrderBy" method="gridOrderBy" params="b, res">
  res.push(
//      {name: "id", title: "По ID"},
      {name: "cod", title: "По коду"},
      {name: "name", title: "По краткому наименованию"},
      {name: "fullName", title: "По полному наименованию"}
  );
</g:javascript>


<g:javascript id="onCtrlOk" method="onCtrlOk">

</g:javascript>
