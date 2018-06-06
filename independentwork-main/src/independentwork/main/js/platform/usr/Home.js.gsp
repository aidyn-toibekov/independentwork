<script type="text/javascript">
  /**
   * Главная страница для usr.
   */

  Ext.define('Jc.usr.Home', {
    extend: 'Jc.Frame',

    onInit: function() {
      this.callParent();
      var th = this;
      var b = th.createBuilder();

      //
      Ext.apply(th, {
        title: UtLang.t('Добро пожаловать'),
        layout: b.layout('autobox')
      });

      //
      th.items = [
        b.frameheader()
      ];

    }

  });

</script>
