<%@ page import="xtofi.main.model.sys.*; jandcode.dbm.dao.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>

<gf:attr name="recId" type="long" ext="true"/>

<gf:groovy>
    <%
        GfFrame gf = args.gf
        GfAttrs a = gf.attrs
        //
        STreeDataStore st = gf.createSTreeStore("AuthUser/priv")
        st.setDaoMethodLoad("loadUserPrivs")
        st.load(id: a.recId)

        a.privTree = st


    %>
</gf:groovy>

<g:javascript>
    th.nopadding = true;
    th.layout = b.layout('vbox');
    //
    var stree = th.stree = b.stree({
        flex: 1,
        store: th.privTree,
        columns: function (b) {
            return [
                b.column('text', {jsclass: "Tree", flex: 2, title: UtLang.t("Название")}),
            ];
        },

        actions: Jc.tofi.auth.actionList(
            b.action({text: UtLang.t("Редактировать список"), icon: "upd", target: "edit:webmod-userpriv", onExec: function (a) {
                Jc.showFrame({frame: "js/platform/usr/authuser/authUser_privsRec.gf", recId: th.recId, onOk: function () {

                    stree.reload()
                }})
            }})
            //b.actionRec({text: UtLang.t("Исключаемые экземпляры сущностей"), icon: "upd", itemId: "NOTID", disabled: true})
        )

    })

    stree.on("select", function (t, r) {
        if (!r) return;

        //Jc.getComponent(th, 'NOTID').enable();
    });

    th.privTree.on("remove", function () {
        //Jc.getComponent(th, 'NOTID').disable();
    })

    th.items = [
        stree
    ];
</g:javascript>