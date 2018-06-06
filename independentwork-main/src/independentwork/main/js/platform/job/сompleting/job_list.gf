<%@ page import="independentwork.main.model.sys.FD_Const; jandcode.dbm.dao.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--


========================================================================= --}%

<gf:groovy>
  <%
    GfFrame gf = args.gf
    Map a = gf.attrs
    //
    SGridDataStore st = gf.createSGridStore("JobCompleting/list")
    st.load();
    a.storeExecutor = st;

    SGridDataStore st1 = gf.createSGridStore("Job/list")
    a.store = st1;

  %>
</gf:groovy>

<g:javascript>
  //
  th.title = UtLang.t('Выполнение задании');
  th.layout = b.layout('vbox');
  //
  th.frameRec = 'js/platform/job/create/job_rec.gf';
  th.daoUpdater = 'Job/updater';
  th.frameRecExecutor = 'js/platform/job/create/jobExecutor_rec.gf';
  th.daoUpdaterExecutor = 'JobExecutor/updater';

  //
  var sgrid = b.sgrid({
    flex: 1,
    //
    store: th.storeExecutor,
    refreshRec: true,
    paginate: true,
    title: UtLang.t("Задания"),
    region: 'west',
    split: true,
    splitterBorder: true,
    collapsible: true,
    perforfCollapse: true,
    autoScroll: true,
    //
    columns: function(b) {
      return [
        b.column('name', {tdCls: "td-wrap", flex: 1}),
        b.column('fileName', {tdCls: "td-wrap", flex: 1}),
        b.column('dte', {tdCls: "td-wrap", width:80}),
        b.column('author', {tdCls: "td-wrap", flex: 1}),
        b.column('subject', {tdCls: "td-wrap", width:100}),
        b.column('cmt', {tdCls: "td-wrap", width:70})
      ];
    },
    //
    actions: Jc.tofi.auth.actionList(
        b.actionRec({
          text: UtLang.t("Просмотр файла задании"),
          icon: "view",
          disabled: true,
          itemId: "VIEW",
          onExec: function(a) {
            Jc.showFrame({frame: "js/frame/file_viewer.gf", fileId: sgrid.getCurRec().get("fileStorage"), id: a.frame, replace: true});
          }})
    )
  });

  var pan = b.panel({
    title: UtLang.t('Описание задания'),
    flex: 1,
    region: 'center',
    layout: b.layout('vbox'),
    items: [
      b.box({
        layout: b.layout('hbox'),
        border: false,
        items: [
          b.button({
            text: UtLang.t("Добавить файл решения"),
            icon: "upd",
            disabled: true,
            itemId: "ANSFILE",
            margins: '5 5 5 5',
            onExec: function() {
              var recData = {};
              recData["id"] = sgrid.getCurRec().getValue("id");
              recData["job"] = th.job
              Jc.showFrame({frame: "js/platform/job/сompleting/setAnsFile_rec.gf",
                recData: recData});
            }
          })
        ]
      }),
      th.desc = Ext.create('Ext.form.HtmlEditor', {
        flex: 1, height: window.innerHeight - 200
      })
    ]
  })

  //
  sgrid.on("select", function(gr, rec) {
    if (!rec) return;
    th.job = rec.getValue("id");
    th.desc.setValue(rec.get("description"))
    Jc.getComponent(th, 'VIEW').enable();
    Jc.getComponent(th, 'ANSFILE').enable();
  });

  //
  var pane = b.box({
    flex: 2,
    border: true,
    layout: b.layout('border'),
    items: [
      sgrid,
      pan
    ]
  });

  //
  th.items = [
    b.pageheader(th.title, 'classifier'),
    pane
  ];
</g:javascript>
