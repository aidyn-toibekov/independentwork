<%@ page import="independentwork.main.model.sys.FD_Const; jandcode.dbm.dao.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--


========================================================================= --}%

<gf:groovy>
  <%
    GfFrame gf = args.gf
    Map a = gf.attrs
    //
    SGridDataStore st = gf.createSGridStore("AuthUser/list")
    st.load(authUserRole: FD_Const.AuthUserRole_teaching)
    a.store = st;

    SGridDataStore st2 = gf.createSGridStore("SubjectUser/list")
    a.store2 = st2



  %>
</gf:groovy>

<g:javascript>
  //
  th.title = UtLang.t('Преподаватели');
  th.layout = b.layout('vbox');
  //
  th.frameRec = 'js/platform/teacher/teacher_rec.gf';
  th.daoUpdater = 'AuthUser/updater';
  th.frameSubjectUser = "js/platform/teacher/teacherSubject_rec.gf";
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
        b.column('phoneNumber', {tdCls: "td-wrap", flex: 1})
      ];
    },
    //
    actions: Jc.tofi.auth.actionList(
        b.actionInsFrame({
          frame: th.frameRec, target: "add:teacher",
          onOk: function(fr) {
            sgrid.reload();
          }
        }),
        b.actionUpdFrame({frame: th.frameRec, disabled: true, itemId: "UPD", target: "upd:teacher"}),
        b.actionDelFrame({daoname: th.daoUpdater, disabled: true, itemId: "DEL", target: "del:teacher"})
    )
  });


  //
  var sgrid2 = b.sgrid({
    //
    title: UtLang.t('Предметы Преподавателя'),
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
        b.column('subject', {tdCls: "td-wrap", flex: 1})
      ];
    },
    actions: Jc.tofi.auth.actionList(
        b.actionInsFrame({frame: th.frameSubjectUser, disabled: true, itemId: 'INS2', target: "add:subjectUser",
          onBeforeShow: function(a) {
            a.recData['authUser'] = th.authUser;
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

    th.authUser = rec.get("id");

    sgrid2.filterStore.set('authUser', th.authUser);
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
    b.pageheader(th.title, 'director'),
    pane
  ];
</g:javascript>
