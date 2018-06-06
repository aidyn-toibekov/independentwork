<%@ page import="independentwork.main.model.sys.FD_Const; jandcode.dbm.dao.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--


========================================================================= --}%

<gf:groovy>
  <%
    GfFrame gf = args.gf
    Map a = gf.attrs
    //
    SGridDataStore st = gf.createSGridStore("AuthUser/list")
    st.load(authUserRole: FD_Const.AuthUserRole_learned)
    a.store = st;

  %>
</gf:groovy>

<g:javascript>
  //
  th.title = UtLang.t('Обучающиеся');
  th.layout = b.layout('vbox');
  //
  th.frameRec = 'js/platform/learner/learner_rec.gf';
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
          frame: th.frameRec, target: "add:learner",
          onOk: function(fr) {
            sgrid.reload();
          }
        }),
        b.actionUpdFrame({frame: th.frameRec, disabled: true, itemId: "UPD", target: "upd:learner"}),
        b.actionDelFrame({daoname: th.daoUpdater, disabled: true, itemId: "DEL", target: "del:learner"})
    )
  });

  //
  sgrid.on("select", function(gr, rec) {
    if (!rec) return;

    th.authUser = rec.get("id");

    Jc.getComponent(th, 'UPD').enable();
    Jc.getComponent(th, 'DEL').enable();
  });
  //
  th.store.on('remove', function() {
    Jc.getComponent(th, 'UPD').disable();
    Jc.getComponent(th, 'DEL').disable();
  });

  //
  th.items = [
    b.pageheader(th.title, 'user'),
    sgrid
  ];
</g:javascript>
