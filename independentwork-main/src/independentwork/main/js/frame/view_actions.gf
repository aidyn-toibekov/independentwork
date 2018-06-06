<%@ page import="jandcode.dbm.data.DataRecord; jandcode.wax.core.utils.gf.*" %>
%{--
    action для удаления внутри просмотра
--}%

<g:javascript>

  th.getActionDel = function(daoname, recId, url, tabUrl, conf) {

    if (!daoname || !recId || !url) {
      return;
    }

    var cfg = {text: Jc.msg.del, icon: "del", onExec: function() {
      Jc.showFrame({frame: 'Jc.frame.DelRec', recId: recId, daoname: daoname, daomethod: "del",
        onOk: function(fr) {
          th.frame.closeFrame();

          var shower = th.frame.shower;
          var frm
          shower.tabPanel.items.each(function(f) {
            if (f.contentUrl === url) {
              frm = f;
            }
          });
          if (frm) {
            if (tabUrl) {
              var index

              //items фрейма (массив)
              var frmItems = frm.items.items[0].items.items;
              frmItems.some(function(item) {
                if (item.getXType() == "tabpanel") {

                  var tabs = item.items.items; //вкладки tabpanel (массив)
                  tabs.some(function(t, p) {
                    if (t.contentUrl === tabUrl) {
                      index = p;
                      return true //нашли - выходим из цикла
                    }
                  });
                }

                if (index) {
                  return true; //нашли - выходим из цикла
                }

              });

              if (index) {
                frm.ctrl.activeTab = index;
              }
            }
            frm.reload();

          }

        }
      });
    }};

    if (conf) {
      Ext.apply(cfg, conf);
    }

    return b.action(cfg);
  };

</g:javascript>
