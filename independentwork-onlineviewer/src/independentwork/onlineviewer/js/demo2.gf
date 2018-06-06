<%@ page import="jandcode.wax.core.utils.WaxTml; jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>

%{-- ========================================================================= --}%
<gf:groovy>
  <%
    GfFrame gf = args.gf
    GfAttrs a = gf.attrs
  %>
</gf:groovy>

%{-- ========================================================================= --}%
<g:javascript>
  //
  th.title = 'Демо';
  th.layout = b.layout('vbox');
  //
  var viewerPanel = b.create('Jc.onlineviewer.ViewerPanel', {
    flex: 1
  });

  var pageHeader;
  th.items = [
    pageHeader = b.pageheader("Файл не выбран", "docum"),
    viewerPanel
  ];

  var inpFileName;
  th.toolbar = [
    b.label(" Полный путь к файлу на сервере"),
    inpFileName = b.input(null, {width: 400}),
    b.action({icon: 'show', text: 'Показать файл', onExec: function() {
      var path = inpFileName.getValue();
      if (path) {
        pageHeader.setText(path);
        viewerPanel.loadFile('system', path);
      }
    }})
  ];

</g:javascript>
