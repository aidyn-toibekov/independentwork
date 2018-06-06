<%@ page import="org.joda.time.DateTime; jandcode.dbm.dblang.DblangService; jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--


========================================================================= --}%

<gf:attr name="fileId" type="long" value="NONE" ext="true"/>

%{-- ========================================================================= --}%

<g:javascript>

  th.shower = 'dialogclose';
  th.width = window.innerWidth - 300;
  th.height = 700;

  th.layout = b.layout('vbox')
  th.autoScroll = true;

  //
  var viewerPanel = b.create('Jc.onlineviewer.ViewerPanel', {
    flex: 1,
    region: 'center',
    maximized: true
  });

  th.on("afterrender", function() {
    viewerPanel.loadFile('filestorage', th.fileId);
  })

  //
  th.items = [
    viewerPanel
  ]



</g:javascript>
