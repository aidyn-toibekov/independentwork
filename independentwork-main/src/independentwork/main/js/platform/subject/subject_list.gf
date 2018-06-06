<%@ page import="jandcode.dbm.dao.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--


========================================================================= --}%

<gf:groovy>
  <%
    GfFrame gf = args.gf
    Map a = gf.attrs
    //
    SGridDataStore st = gf.createSGridStore("Subject/list")
    st.load()
    a.store = st;

    SGridDataStore st2 = gf.createSGridStore("SubjectUser/list")
    a.store2 = st2



  %>
</gf:groovy>

<g:javascript>
  //
  th.title = UtLang.t('Предметы');
  th.layout = b.layout('vbox');
  //
  th.frameRec = 'js/platform/subject/subject_rec.gf';
  th.daoUpdater = 'Subject/updater';
  th.frameSubjectUser = "js/platform/subject/subjectUser_rec.gf";
  th.daoUpdaterSubjectUser = "SubjectUser/updater";

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
        b.column('name', {
          tdCls: "td-wrap", flex: 1
        }),
        b.column('fullName', {tdCls: "td-wrap", flex: 1}),
        b.column('cmt', {tdCls: "td-wrap", flex: 1})
      ];
    },
    //
    actions: Jc.tofi.auth.actionList(
        b.actionInsFrame({
          frame: th.frameRec, target: "add:subject"
        }),
        b.actionUpdFrame({frame: th.frameRec, disabled: true, itemId: "UPD", target: "upd:subject"}),
        b.actionDelFrame({daoname: th.daoUpdater, disabled: true, itemId: "DEL", target: "del:subject"})
    )
  });


  //
  var sgrid2 = b.sgrid({
    //
    title: UtLang.t('Преподаватели'),
    store: th.store2,
    //
    flex: 0.3,

    region: 'east',
    split: true,
    splitterBorder: true,
    collapsible: true,
    perforfCollapse: true,

    autoScroll: true,
    //
    refreshRec: true,
    columns: function(b) {
      return [
        b.column('authUser', {tdCls: "td-wrap", flex: 1})
      ];
    },
    actions: Jc.tofi.auth.actionList(
        b.actionInsFrame({frame: th.frameSubjectUser, disabled: true, itemId: 'INS2', target: "add:subjectUser",
          onBeforeShow: function(a) {
            a.recData['subject'] = th.subject;
          }, onOk: function() {
            sgrid2.reload();
          }
        }),
        b.actionUpdFrame({frame: th.frameSubjectUser, disabled: true, itemId: "UPD2", target: "update:subjectUser"}),
        b.actionDelFrame({daoname: th.daoUpdaterSubjectUser, disabled: true, itemId: 'DEL2', target: "delete:subjectUser"})
    )
  });


  //
  sgrid.on("select", function(gr, rec) {
    if (!rec) return;

    th.subject = rec.get("id");

    sgrid2.filterStore.set('subject', th.subject);
    sgrid2.filterStore.set('orderBy', 'name');
    sgrid2.reload();

    Jc.getComponent(th, 'UPD').enable();
    Jc.getComponent(th, 'DEL').enable();
    Jc.getComponent(th, 'INS2').enable();
  });
  //
  th.store.on('remove', function() {
    Jc.getComponent(th, 'UPD').disable();
    Jc.getComponent(th, 'DEL').disable();
    Jc.getComponent(th, 'INS2').disable();
  });

  //
  sgrid2.on("select", function(gr, rec) {
    if (!rec) return;

    Jc.getComponent(th, 'UPD2').enable();
    Jc.getComponent(th, 'DEL2').enable();
  });
  //
  th.store2.on('remove', function() {
    Jc.getComponent(th, 'UPD2').disable();
    Jc.getComponent(th, 'DEL2').disable();
  });

  //
  var pane = b.box({
    flex: 2,
    border: true,
    layout: b.layout('border'),
    items: [
      sgrid,
      sgrid2
    ]
  });

  //
  th.items = [
    b.pageheader(th.title, 'tehpd'),
    pane
  ];
</g:javascript>
