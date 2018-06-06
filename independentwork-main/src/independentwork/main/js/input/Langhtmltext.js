/**
 * Ввод многоязыкового memo-поля
 */
Ext.define('Jc.input.Langhtmltext', {
    extend: 'Ext.tab.Panel',

    constructor: function(config) {
        var th = this;
        var cfg = Ext.apply({
            height: 110,
            width: 350,
            tabPosition: 'bottom',
            plain: true,
            border: false,
            bodyBorder: false,
            icon_true: 'icon-truegray',
            icon_false: 'icon-false'
        }, config);
        //
        var model = Jc.dbm.DataBinder.getModel(th);
        //
        th.items = [];
        var curTab;
        Ext.each(model.langs, function(lang) {
            var p = Ext.create('Ext.form.HtmlEditor', {
                title: lang,
                enableSourceEdit: false,
                iconCls: cfg.icon_false,
                itemId: lang
            });
            p.on("blur", function() {
                th._updateLangMarkers();
            });
            th.items.push(p);
            if (lang == model.lang) {
                curTab = p;
            }
        });
        //
        th.callParent([cfg]);
        // значение по умолчанию
        th.setValue(th.value);
        // ставим текущую для текущего языка
        th.setActiveTab(curTab);
    },

    _updateLangMarkers: function() {
        var th = this;
        var v = this.getValue();
        this.tabBar.items.each(function(z) {
            var lang = z.text;
            var v1 = v[lang];
            if (v1) {
                z.setIconCls(th.icon_true);
            } else {
                z.setIconCls(th.icon_false);
            }
        });
    },

    getValue: function() {
        var th = this;
        var v = {};
        var model = Jc.dbm.DataBinder.getModel(th);
        Ext.each(model.langs, function(lang) {
            var m = th.getComponent(lang);
            v[lang] = m.getValue();
        });
        return v;
    },

    /**
     * В качестве значения: {ru:'a',en:'b'...}
     */
    setValue: function(v) {
        var th = this;
        var model = Jc.dbm.DataBinder.getModel(this);
        var vv = {};
        if (!v) {
        } else if (Ext.isString(v)) {
            vv[model.lang] = v;
        } else {
            vv = Ext.apply({}, v);
        }
        Ext.each(model.langs, function(lang) {
            var m = th.getComponent(lang);
            m.setValue(vv[lang]);
        });
        th._updateLangMarkers();
    },

    dataToControl: function() {
        var th = this;
        if (!th.dataIndex) return;
        //
        var v = Jc.lang.getLangDataFromRec(th, th.dataIndex);
        this.setValue(v);
    },

    controlToData: function() {
        var v = this.getValue();
        Jc.lang.setLangDataToRec(this, this.dataIndex, v);
    }

});
