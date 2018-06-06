Ext.define('Jc.input.CbdictVis', {
    extend: 'Jc.input.Cbdict',
    constructor: function(config) {
        var th = this;
        th.callParent(arguments);
        //
        var st = th.store.domain.createStore();

        th.store.each(function(r) {
            if (r.get("vis") == 1) {
                st.add(r.getValues());
            }
        });
        th.store = st;
    }
});