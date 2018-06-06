<%@ page import="jandcode.dbm.dao.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--

Список пользовательских ролей

========================================================================= --}%
<gf:groovy>
    <%
        GfFrame gf = args.gf
        Map a = gf.attrs
        //
        SGridDataStore st = gf.createSGridStore("AuthRole/list")
        st.load()

        a.store = st

    %>
</gf:groovy>

<g:javascript>
    //
    th.title = UtLang.t('Роли');
    th.layout = b.layout('vbox');
    //
    var sgrid = b.sgrid({
        flex: 1,
        //
        store: th.store,
        refreshRec: true,
        paginate: true,
        //
        filterPanel: true,
        filterFrame: function(b) {
            return [
                b.input2("name")
            ];
        },
        //
        orderBy: [
            {name: "name", title: UtLang.t("По наименованию")},
            {name: "fullName", title: UtLang.t("По полному наименованию")}
        ],
        //
        columns: function (b) {
            return [
                b.column("name", {flex: 1}),
                b.column("fullName", {flex: 1}),
                b.column('cmt')
            ];
        },
        //
        actions: Jc.tofi.auth.actionList(
                b.actionInsFrame({frame: 'js/platform/usr/authrole/authRole_rec.gf', text: UtLang.t("Добавить"), target: "add:webmod-role"}),
                b.actionUpdFrame({frame: 'js/platform/usr/authrole/authRole_rec.gf', disabled: true, itemId: "UPD", target: "update:webmod-role"}),
                b.actionDelFrame({daoname: 'AuthRole/updater', disabled: true, itemId: "DEL", target: "delete:webmod-role"}),
                b.actionViewFrame({frame: 'js/platform/usr/authrole/authRole_view.gf', text: UtLang.t('Выбрать'), icon: 'choice', disabled: true, itemId: 'view'})
            )
    });

    sgrid.on("select", function (gr, rec) {
        if (!rec) return;

        Jc.getComponent(th, 'UPD').enable();
        Jc.getComponent(th, 'DEL').enable();
        Jc.getComponent(th, 'view').enable();
    });

    th.store.on('remove', function () {
        Jc.getComponent(th, 'UPD').disable();
        Jc.getComponent(th, 'DEL').disable();
        Jc.getComponent(th, 'view').disable();
    });

    //
    th.items = [
        b.frameheader({icon: "role"}),
        sgrid
    ];
</g:javascript>
