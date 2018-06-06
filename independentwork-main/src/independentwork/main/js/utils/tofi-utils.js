/**
 * Утилиты для ТОФИ
 */

Ext.namespace("Jc.tofi");

/**
 * Настройка полей ввода Langstring на синхронный ввод.
 * Если значения в i2 не менялось, оно принимает значения из i1.
 * Используется для ввода пар:  "name-fullName"
 * @param i1 первое поле ввода (основное) (обычно name)
 * @param i2 второе поле ввода (обычно fullName)
 */
Jc.tofi.syncInputLangstring = function (i1, i2) {
    var sv1, sv2;
    i1.on("focus", function (a) {
        // запоминаем что было
        sv1 = i1.getValue();
        sv2 = i2.getValue();
    });
    i1.on("blur", function (a) {
        // текущие значения
        var v1 = i1.getValue();
        var v2 = i2.getValue();
        // сравниваем
        for (var f in sv1) {
            if (sv1[f] == sv2[f] || !sv2[f]) {
                // были одинаковы или пусто - делаем одинаковыми
                v2[f] = v1[f];
            }
        }
        i2.setValue(v2);
    });

    /*
     i2.on("blur", function(a) {
     // текущие значения
     var v1 = i1.getValue();
     var v2 = i2.getValue();
     // сравниваем
     for (var f in v1) {
     if (!v2[f]) {
     // пусто - делаем одинаковыми
     v2[f] = v1[f];
     }
     }
     i2.setValue(v2);
     });
     */

};

/**
 * Текст заголовка фрейма с кодом и наименованием
 * @param rec запись
 * @return {*}
 */
Jc.tofi.pageheaderEntityText = function (rec) {
    return Jc.format('<span class="jc-pageheader-text-high">{0}</span> : {1}', rec.get('cod'), rec.get('name'));
};

////// FIXES: wax //////

Jc.isDateEmpty = function (d) {
    if (!d) return true;
    if (!Ext.isDate(d)) return true;
    var y = d.getFullYear();
    if (y >= 3333) return true;
    if (y <= 1970) return true;
    return false;
};

Jc.isEmptyObject = function (obj) {
    if (!obj) return true;
    var name;
    for (name in obj) {
        return false;
    }
    return true;
};

/**
 * Форматирует дату в дату
 *
 * @param v
 * @return {*}
 */
Jc.tofi.valueDateRender = function (v) {
    return Jc.dateToText(v, this.format);
}

/**
 * Форматирует дату в время
 *
 * @param v
 * @return {*}
 */
Jc.tofi.valueTimeRender = function (v) {
    if (v) return Ext.Date.format(v, Jc.ini.timeFormat)
    else return Jc.ini.dateEmptyText
}

/**
 * Форматирует дату в дату и время
 *
 * @param v
 * @return {*}
 */
Jc.tofi.valueDateTimeRender = function (v) {
    if (v) return Ext.Date.format(v, Jc.ini.datetimeFormat)
    else return Jc.ini.dateEmptyText
}

/**
 * Обход дерева (Ext.stavka.NodeInterface) слева
 * @param node дерево
 * @param fn функция выполняющаяся к каждому узлу дерева. Если функция вернет false обход прекращается и возвратит false
 * @return {*}
 */
Jc.tofi.bypassTree = function (node, fn) {
    var result = fn(node);

    if (result === false) return false;

    return Ext.Array.every(node.childNodes, function (n) {
        return Jc.tofi.bypassTree(n, fn);
    });
}

Ext.namespace("Jc.tofi.auth");
/**
 * Проверка доступа текущего пользователя к акшну по свойству target
 * в качестве параметров принимает список акшнов
 * @return массив акшнов
 */
Jc.tofi.auth.actionList = function () {
    var list = []
    for (i = 0; i < arguments.length; i++) {
        list[i] = arguments[i];
    }

    list.forEach(function (a) {
        var cfg = {};
        if (a.initialConfig) {
            Ext.apply(cfg, a.initialConfig);
        }

        var target = cfg.target
        if (target) {
            var hasAccess = Jc.tofi.auth.checkTarget(target)
            if (hasAccess) {
                if (Jc.daoinvoke("AuthUser/util", "hasDirectAccess", [target]) == false) {
                    Ext.apply(cfg, {
                        onBeforeExec: function () {
                            Jc.showMsg("Доступ через бизнес-процессы");
                            return false;
                        }});
                }
            } else {
                Ext.apply(cfg, {hidden: true,
                    listeners: {beforeshow: function (c) {
                        return false;
                    }},
                    onBeforeExec: function () {
                        return false;
                    }});
            }
            var onBeforeExec = cfg.onBeforeExec;
            cfg.onBeforeExec = function () {
                var ci = Jc.tofi.auth.getCredentialsInfo(target);
                if (ci.guest) {
                    Jc.showError(UtLang.t("Вы вышли из системы. Обновите страницу."));
                    return false;
                }
                if (!ci.hasAccess) {
                    Jc.showError(UtLang.t("У вас недостаточно прав для выполнения операции"));
                    return false;
                }
                if (ci.hasDirectAccess === false) {
                    Jc.showMsg("Доступ через бизнес-процессы");
                    return false;
                }
                if (onBeforeExec)
                    onBeforeExec(arguments);
            }
        }
        Ext.apply(a.initialConfig, cfg);
    });

    return list;
}

/**
 * Проверка доступа текущего пользователя к элементам табпанели
 * @param items массив элементов (panel) для tabpanel
 * @return массив элементов табпанели к которому имеет доступ тек. пользователь
 */
Jc.tofi.auth.tabpanelItemList = function (items) {
    var items = items.filter(function (panel, i) {

        if (panel.target) {
            return Jc.tofi.auth.checkTarget(panel.target);
        } else {
            return true;
        }

    });
    return items;
}

/**
 * Проверить цель.
 * @param target        цель
 * @param generateError true - генерится ошибка,
 *                      false - возвращается false
 */
Jc.tofi.auth.checkTarget = function (target, generateError) {
    if (!generateError) {
        generateError = false;
    }
    return Jc.daoinvoke("AuthUser/util", "checkTarget", [target, generateError]);
}

Jc.tofi.auth.getCredentialsInfo = function (target) {
    return Jc.daoinvoke("AuthUser/util", "getCredentialsInfo", [target]);
}


/**
 * Вызывает фрейм смены порядка для списка
 * @param b
 * @param cfg
 */
Jc.tofi.actionOrdGrid = function (b, cfg) {

    var daoname = cfg.daoname;
    var daoparams = cfg.daoparams;
    var store = cfg.store;
    var columns = cfg.columns;

    delete cfg.daoname;
    delete cfg.daoparams;
    delete cfg.store;
    delete cfg.columns;

    var nCfg = {
        icon: 'order-sort',
        text: UtLang.t('Изменить порядок'),
        onExec: function (a) {
            if (store.size() < 2) {
                Jc.showMsg(UtLang.t("Для изменения порядка должно быть не менее двух записей"))
                return;
            }

            Jc.showFrame({
                frame: "js/frame/changeOrdGrid.gf",
                daoname: daoname,
                local: {
                    daoparams: daoparams,
                    store: store,
                    columns: columns
                },
                onOk: function (fr) {
                    store.daoparams = daoparams;
                    store.load();
                }
            });
        }
    }

    nCfg = Ext.apply(nCfg, cfg);

    return b.actionGrid(nCfg);
}

Jc.tofi.actionOrdFullGrid = function (b, cfg) {

    var daoname = cfg.daoname;
    var daoparams = cfg.daoparams;
    var store = cfg.store;
    var columns = cfg.columns;

    delete cfg.daoname;
    delete cfg.daoparams;
    delete cfg.store;
    delete cfg.columns;

    var nCfg = {
        icon: 'order-sort',
        text: UtLang.t('Изменить порядок'),
        onExec: function (a) {
            if (store.size() < 2) {
                Jc.showMsg(UtLang.t("Для изменения порядка должно быть не менее двух записей"))
                return;
            }

            Jc.showFrame({
                frame: "js/frame/changeOrdFullGrid.gf",
                daoname: daoname,
                local: {
                    daoparams: daoparams,
                    store: store,
                    columns: columns
                },
                onOk: function (fr) {
                    store.daoparams = daoparams;
                    store.load();
                }
            });
        }
    };

    nCfg = Ext.apply(nCfg, cfg);

    return b.actionGrid(nCfg);
}

/**
 * Вызывает фрейм смены порядка для дерева
 * @param b
 * @param cfg
 */
Jc.tofi.actionOrdTree = function (b, cfg) {

    var daoname = cfg.daoname;
    var daoparams = cfg.daoparams;
    var store = cfg.store;
    var columns = cfg.columns;

    delete cfg.daoname;
    delete cfg.daoparams;
    delete cfg.store;
    delete cfg.columns;

    var nCfg = {
        icon: 'order-sort',
        text: UtLang.t('Изменить порядок'),
        onExec: function (a) {
            Jc.showFrame({
                frame: "js/frame/changeOrdTree.gf",
                daoname: daoname,
                local: {
                    daoparams: daoparams,
                    store: store,
                    columns: columns
                },
                onOk: function (a) {
                    store.daoparams = daoparams;
                    store.load();
                }
            });
        }
    }

    nCfg = Ext.apply(nCfg, cfg);

    return b.actionGrid(nCfg);
}

