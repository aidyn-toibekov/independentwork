<%@ page import="jandcode.wax.core.utils.WaxTml; jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>

%{-- ========================================================================= --}%
<gf:groovy>
  <%
    GfFrame gf = args.gf
    GfAttrs a = gf.attrs
    //
    a.store = gf.daoinvoke("DemoFiles/list", "load")

  %>
</gf:groovy>

%{-- ========================================================================= --}%
<g:javascript>
  //
  th.title = 'Демо';
  th.layout = b.layout('border');
  //
  var grid;

  var viewerPanel = b.create('Jc.onlineviewer.ViewerPanel', {
    region: 'center'
  });

  th.items = [
    b.pageheader("Просмотр файлов", "docum", {region: "north"}),
    grid = b.grid({
      region: 'west',
      split: true,
      hideHeaders: true,
      width: 200,
      columns: [
        b.column("path", {flex: 1})
      ]
    }),
    viewerPanel
  ];

  grid.on("selectionchange", function(t, r) {
    var path = r[0].get('path');
    viewerPanel.loadFile('vdir', path);
  });

</g:javascript>
