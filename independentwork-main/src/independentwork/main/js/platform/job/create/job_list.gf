<%@ page import="independentwork.main.model.sys.FD_Const; jandcode.dbm.dao.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--


========================================================================= --}%

<gf:groovy>
  <%
    GfFrame gf = args.gf
    Map a = gf.attrs
    //
    SGridDataStore st = gf.createSGridStore("Job/list")
    st.load();
    a.store = st;

    SGridDataStore st1 = gf.createSGridStore("JobExecutor/list")
    a.storeExecutor = st1;

  %>
</gf:groovy>

<g:javascript>
  //
  th.title = UtLang.t('Назначение задании');
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
    store: th.store,
    refreshRec: true,
    paginate: true,
    region: 'center',
    autoScroll: true,
    //
    columns: function(b) {
      return [
        b.column('name', {tdCls: "td-wrap", flex: 1}),
        b.column('fileName', {tdCls: "td-wrap", flex: 1}),
        b.column('dte', {tdCls: "td-wrap", flex: 1}),
        b.column('author', {tdCls: "td-wrap", flex: 1}),
        b.column('subject', {tdCls: "td-wrap", flex: 1}),
        b.column('cmt', {
          tdCls: "td-wrap", flex: 1
        })
      ];
    },
    //
    actions: Jc.tofi.auth.actionList(
        b.actionInsFrame({
          frame: th.frameRec, target: "add:assignment-job",
          onOk: function(fr) {
            sgrid.reload();
          }
        }),
        b.actionUpdFrame({
          frame: th.frameRec, disabled: true, itemId: "UPD", target: "upd:assignment-job"
        }),
        b.actionDelFrame({
          daoname: th.daoUpdater, disabled: true, itemId: "DEL", target: "del:assignment-job"
        }),
        b.actionRec({
          text: UtLang.t("Просмотр файла"),
          icon: "view",
          disabled: true,
          itemId: "VIEW",
          target: "view:assignment-job",
          onExec: function(a) {
            Jc.showFrame({frame: "js/frame/file_viewer.gf", fileId: sgrid.getCurRec().get("fileStorage"), id: a.frame, replace: true});
          }})
    )
  });

  //
  var sgrid1 = b.sgrid({
    flex: 1,
    //
    store: th.storeExecutor,
    refreshRec: true,
    autoScroll: true,

    title: UtLang.t('Исполнители Задании'),
    flex: 0.5,
    region: 'east',
    split: true,
    splitterBorder: true,
    collapsible: true,
    perforfCollapse: true,
    //
    columns: function(b) {
      return [
        b.column('executor', {tdCls: "td-wrap", flex: 1, title: UtLang.t("Исполнитель")}),
        b.column('hasAnswer', {width: 80, title: UtLang.t("Есть ответ")})
      ];
    },
    //
    actions: Jc.tofi.auth.actionList(
        b.actionInsFrame({
          frame: th.frameRecExecutor, target: "add:assignment-job-executor", disabled: true, itemId: "INS1",
          onBeforeShow: function(a) {
            a.recData['job'] = th.job;
          },
          onOk: function(fr) {
            sgrid1.reload();
          }
        }),
        b.actionUpdFrame({
          frame: th.frameRecExecutor, disabled: true, itemId: "UPD1", target: "upd:assignment-job-executor"
        }),
        b.actionDelFrame({daoname: th.daoUpdaterExecutor, disabled: true, itemId: "DEL1", target: "del:assignment-job-executor"}),
        b.actionRec({
          text: UtLang.t("Просмотр ответа"),
          icon: "view",
          disabled: true,
          itemId: "VIEW1",
          onExec: function(a) {
            Jc.showFrame({frame: "js/frame/file_viewer.gf", fileId: sgrid1.getCurRec().get("fileStorage"), id: a.frame, replace: true});
          }})
    )
  });

  var pan = b.panel({
    title: UtLang.t('Описание задания'),
    flex: 0.3,
    region: 'south',
    split: true,
    splitterBorder: true,
    collapsible: true,
    perforfCollapse: true,
    layout: b.layout('hbox'),
    items: [
      th.desc = Ext.create('Ext.form.HtmlEditor', {
        enableSourceEdit: false,
        width: "100%", height: "100%",
        enableColors: false,
        enableAlignments: false,
        enableFontSize: false,
        enableFormat: false,
        enableLinks: false,
        enableSourceEdit: false,
        enableLists: false,
      })
    ]
  })

  //
  sgrid.on("select", function(gr, rec) {
    if (!rec) return;

    th.job = rec.get("id");

    sgrid1.filterStore.set('job', th.job);
    sgrid1.filterStore.set('orderBy', 'name');
    sgrid1.reload();

    th.desc.setValue(rec.get("description"))

    Jc.getComponent(th, 'UPD').enable();
    Jc.getComponent(th, 'DEL').enable();
    Jc.getComponent(th, 'VIEW').enable();
    Jc.getComponent(th, 'INS1').enable();
  });
  //
  th.store.on('remove', function() {
    Jc.getComponent(th, 'UPD').disable();
    Jc.getComponent(th, 'VIEW').disable();
    Jc.getComponent(th, 'DEL').disable();

    sgrid1.filterStore.set('job', null);
    sgrid1.filterStore.set('orderBy', 'name');
    sgrid1.reload();
  });

  //
  sgrid1.on("select", function(gr, rec) {
    if (!rec) return;

    Jc.getComponent(th, 'VIEW1').disable();
    if(rec.get("fileStorage")>0){
      Jc.getComponent(th, 'VIEW1').enable();
    }

    Jc.getComponent(th, 'UPD1').enable();
    Jc.getComponent(th, 'DEL1').enable();
  });
  //
  th.storeExecutor.on('remove', function() {
    Jc.getComponent(th, 'UPD1').disable();
    Jc.getComponent(th, 'DEL1').disable();
  });

  //
  var pane = b.box({
    flex: 2,
    border: true,
    layout: b.layout('border'),
    items: [
      sgrid,
      sgrid1,
      pan
    ]
  });

  //
  th.items = [
    b.pageheader(th.title, 'classifier'),
    pane
  ];
</g:javascript>
