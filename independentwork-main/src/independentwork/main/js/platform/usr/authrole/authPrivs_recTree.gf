<%@ page import="jandcode.utils.UtLang; jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--

========================================================================= --}%
<gf:attr name="recId" type="long" ext="true"/>
  <gf:attr name="privdaoname" type="string"/>

<gf:groovy>

    <%
        // получаем ссылку на фрейм
        GfFrame gf = args.gf
        // получаем ссылку на атрибуты
        def a = gf.attrs
        //
        STreeDataStore privTree = gf.createSTreeStore(a.privdaoname)
        privTree.load(id: a.recId)
        a.privTree = privTree
    %>

</gf:groovy>

%{-- ========================================================================= --}%
<g:javascript>
    th.width = 600;  //fix width memo
    th.height = 400;
    th.layout = b.layout("vbox");
    th.shower = "dialog";

    var stree = th.stree = b.stree({
        flex: 1,
        store: th.privTree,
        selType: 'cellmodel',
        plugins: [
            Ext.create('Ext.grid.plugin.CellEditing', {
                clicksToEdit: 1
            })
        ],
        columns: function (b) {
            return [
                b.column('text', {jsclass: "Tree", flex: 2, title: UtLang.t("Название")})
            ];
        },
        actions: [
            b.actionRec({icon: "ok", tooltip: UtLang.t("Выбрать все дочерние привилегии"), itemId: "ALL", disabled: true,
                onExec: function (a) {
                    var node = a.rec, grid = a.grid;
                    //при выборе "дочки" выбираем и всех "родителей"
                    up(node, function (n) {
                        n.set("checked", true);
                    });
                    //
                    node.cascadeBy(function (n) {
                        n.set("checked", true);
                    });
                    //
                    grid.getStore().dictdata.resolveDictStore(grid.getStore());
                    grid.getView().refresh();
                    //
                    node.expand(true);
                }}),
            getBusProcessAction(false),
            getBusProcessAction(true)
        ]
    });

    th.items = [
        stree
    ];

    stree.on("edit", function (editor, e) {
        e.grid.getStore().dictdata.resolveDictRec(e.record);
        e.grid.getView().refresh();
    });

    stree.on("checkchange", function (node, checked) {

        if (!checked) {

            //при uncheck очищаем бизнесс процесс
            clearBusProcess(node);

            Jc.getComponent(th, 'BPB').disable();
            Jc.getComponent(th, 'BPA').disable();
        } else {
            if (node.get("acceptBusProcess") == true) {
                Jc.getComponent(th, 'BPB').enable();
                Jc.getComponent(th, 'BPA').enable();
            }
        }

        //при выборе "дочки" выбираем и всех "родителей"
        if (checked) {
            up(node, function (n) {
                n.set("checked", true);
            })
        }

        if (!checked && !node.isLeaf()) {
            node.cascadeBy(function (child) {
                child.set("checked", false);
                if (child.get("busProcessBefore") > 0
                        || child.get("busProcessAfter") > 0) {
                    clearBusProcess(child);
                }
            });
        }

        stree.getStore().dictdata.resolveDictStore(stree.getStore());
        stree.getView().refresh();
    });

    stree.on("select", function (tree, rec) {
        if (!rec) return;

        Jc.getComponent(th, 'ALL').enable();
        if (rec.get("acceptBusProcess") == true && rec.get("checked") == true) {
            Jc.getComponent(th, 'BPB').enable();
            Jc.getComponent(th, 'BPA').enable();
        } else {
            Jc.getComponent(th, 'BPB').disable();
            Jc.getComponent(th, 'BPA').disable();
        }
    });

    function getBusProcessAction(after) {
        var actionText = UtLang.t("Бизнес-процесс перед"),
                busProcessField = "busProcessBefore",
                busProcessNameField = "busProcessBeforeName",
                itemID = "BPB",
                what = "before";
        if (after) {
            actionText = UtLang.t("Бизнес-процесс после");
            busProcessField = "busProcessAfter";
            busProcessNameField = "busProcessAfterName";
            itemID = "BPA";
            what = "after";
        }
        return b.actionRec({text: actionText, icon: 'upd', itemId: itemID, disabled: true, onExec: function (a) {
            var rec = a.rec;
            if (rec.get("checked") == true && rec.get("acceptBusProcess") == true) {
                Jc.showFrame({frame: 'js/platform/usr/authrole/busProcess_tree.gf', busProcess: rec.get(busProcessField),
                    onOk: function (fr) {
                        var checked = fr.grid.getChecked();
                        if (checked.length == 0) {
                            clearBusProcess(rec, what);
                        } else {
                            rec.set(busProcessField, fr.busProcess);
                            rec.set(busProcessNameField, checked[0].get("name"));
                        }
                    }});
            }
        }})
    }

    function clearBusProcess(rec, what) {
        if (what == "before" || !what) {
            rec.set("busProcessBefore", 0);
            rec.set("busProcessBeforeName", null);
        }
        if (what == "after" || !what) {
            rec.set("busProcessAfter", 0);
            rec.set("busProcessAfterName", null);
        }
    }

    /**
     * выполняет переданную функцию ко всем родительским узлам переданного узла включая переданного узла
     * @param node узел
     * @param fn функция (аргумент - текущий узел)
     */
    function up(node, fn) {
        fn(node);
        var parent = node.parentNode;
        if (!parent.isRoot()) {
            up(parent, fn);
        }
    }


</g:javascript>

<g:javascript id="onBeforeOk" method="onBeforeOk">

    th.arr = []
    th.stree.getView().getChecked().forEach(function (r) {
        var rec = {}
        rec.id = r.get("id")
        rec.busProcessBefore = r.get("busProcessBefore")
        rec.busProcessAfter = r.get("busProcessAfter")
        th.arr.push(rec);
    })

</g:javascript>
