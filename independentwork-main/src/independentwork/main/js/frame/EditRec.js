/**
 * Предок для редактирования записи указанного домена указанным dao.
 */
Ext.define('Jc.frame.EditRec', {
    extend: 'Jc.Frame',

    /**
     * Домен записи. По этому домену будет создана store,
     * запись которой будет редактироваться.
     */
    domain: null,

    /**
     * dao для обработки записи. Из него используются следующие методы:
     * - loadRec(id) чтение записи
     * - ins(rec):id - вставка записи, возвращает вставленный id
     * - upd(rec) - обновление записи
     */
    daoname: null,

    /**
     * Метод для вставки записи
     */
    daomethod_ins: "ins",

    /**
     * Метод для изменения записи
     */
    daomethod_upd: "upd",

    /**
     * id редактируемой записи. Если не указано, то фрейм работает в режиме вставки
     * новой записи. Если указано, то в режиме редактирования указанной записи.
     * После редактирования новой записи в этом поле id добавленной записи.
     */
    recId: null,

    /**
     * Данные записи. Если запись новая - это значения по умолчанию. Если редактируется,
     * то значения указанные тут заменяют загруженные данные записи с сервера.
     */
    recData: null,

    onInit: function() {
        this.callParent();
        var th = this;
        var b = th.createBuilder();
        //
        Ext.apply(th, {
            shower: 'dialog',
            title: 'Редактирование записи',
            layout: b.layout('table')
        });
        //
        th.mode = "ins";
        if (th.recId) {
            th.mode = "upd";
        }
        if (!th.recData) {
            th.recData = {};
        }
        var store = th.store = b.createStore(th.domain, {
            autoLoad: th.mode != "ins",
            daoname: th.daoname,
            daomethod: "loadRec",
            daoparams: [th.recId]
        });
        if (th.mode == "ins") {
            store.add(th.recData);
            store.getCurRec().resolveDicts();
        }
        store.on("load", function(st, rs, ok) {
            //successful ??
            if (!ok) {
                th.closeFrame();
            } else {
                store.getCurRec().set(th.recData);  // значения по умолчанию для редактируемой
                th.onAfterLoad();
                th.dataToControl();
            }
        });
        //
        th.onCreateControls(b);
        //
    },

    /**
     * Создание control для этого фрейма
     * @param b builder, созданный в onInit
     */
    onCreateControls: function(b) {
    },

    onOk: function() {
        this.controlToData();
        this.saveData();
    },

    saveData: function() {
        var th = this;
        if (th.mode == "ins") {
            th.recId = Jc.daoinvoke(th.daoname, th.daomethod_ins, [th.store]);
            th.store.getCurRec().set("id", th.recId);
        } else {
            Jc.daoinvoke(th.daoname, th.daomethod_upd, [th.store]);
        }
    },

    /**
     * Вызывается после загрузки перед dataToControl.
     * Все control уже созданы.
     */
    onAfterLoad: function() {
    },

    onLoadData: function() {
        if (this.mode == "ins") {
            this.onAfterLoad();
        }
    }

});