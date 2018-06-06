/**
 * Смена пароля
 */
Ext.define('Jc.auth.ChangePassword', {
    extend: 'Jc.frame.EditRec',

    domain: "AuthUser.edit",
    daoname: "AuthUser/updater",
    daomethod_upd: "updPasswd",

    onCreateControls: function(b) {
        var th = this;
        this.title = UtLang.t("Изменение пароля");
        //
        this.items = [
            b.delim(UtLang.t("Пользователь")),
            b.datalabel2("name"),
            b.datalabel2("fullName"),

            b.delim(UtLang.t("Пароль")),
            b.input2("passwd"),
            b.input2("passwd2")
        ];
    }

});
 