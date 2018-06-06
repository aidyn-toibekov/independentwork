<%@ page import="jandcode.wax.core.utils.*; jandcode.dbm.*; jandcode.auth.*; jandcode.utils.*; jandcode.web.*" %>
<%
    WaxTml ut = new WaxTml(this)
    def userId = ut.request.params.getValueLong("id")
    IUserInfo userInfo = ut.model.daoinvoke("AuthUser/auth", "getUserInfo", userId)
    def roleNames = []
    def privNames = []
    for (r in userInfo.roles) {
        roleNames.add(r.title)
    }
    for (r in userInfo.privs) {
        privNames.add(r.title)
    }
%>

<div id="~id~x">
</div>

<script type="text/javascript">
    TH.onReady(function () {
        var th = this;
        //
        th.title = UtLang.t('Профиль пользователя');
        var b = th.createBuilder();

        var fh = b.frameheader({icon: 'user'});

        var items = [];
        items.push(
                b.label(UtLang.t("Полное имя")),
                b.datalabel('${userInfo.fullname}', {jsclass: "String"}),
                b.label(UtLang.t("Заблокирован")),
                b.datalabel('${userInfo.locked}', {jsclass: "Boolean"}),
                b.delim(UtLang.t("Информация по правах")),
                b.label(UtLang.t("Роли")),
                b.datalabel('${UtString.join(roleNames,", ")}', {jsclass: "String"}),
                b.label(UtLang.t("Привилегии")),
                b.datalabel('${UtString.join(privNames,", ")}', {jsclass: "String"})
        );
        var db = b.databox({
            items: items
        });


        this.toolbar = [
            b.action({text: UtLang.t('Сменить пароль'), icon: 'key', onExec: function () {
                Jc.showFrame({frame: 'Jc.auth.ChangePassword', recId:${userId}});
            }})
        ];

        //
        var box = b.box({
            renderTo: '~id~x',
            layout: b.layout('autobox'),
            items: [fh, db]
        });
    });
</script>