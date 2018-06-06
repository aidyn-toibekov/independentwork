<%@ page import="jandcode.lang.*" %>
<script type="text/javascript">
  Ext.define("Jc.App", {
    extend: "Jc.BaseApp",

    createMainMenu: function() {
      //
      var menu = Jc.menu;
      var item = Jc.action;
      //
      var logo = Ext.create('Jc.control.PageHeader', {
        text: Jc.ini.app.title,
        icon: Jc.url("page/logo-small.png"),
        width: 230,
        listeners: {
          click: {
            element: 'el',
            fn: function() {
              Jc.app.home();
            }
          }
        }
      });
      //
      return [logo, '-'].concat(this.createMenuForUser());
    },

    createMenuForUser: function() {
      var mm = [
        Jc.action({text: UtLang.t('Тестовые файлы'), icon: "info", scope: this, onExec: this.home}),
        Jc.action({text: UtLang.t('Любые файлы'), icon: "info", scope: this, onExec: this.demo2}),
      ];
      return mm;
    },

    home: function() {
      this.demo1();
    },

    demo1: function() {
      Jc.showFrame({frame: "js/demo1.gf", id: true});
    },

    demo2: function() {
      Jc.showFrame({frame: "js/demo2.gf", id: true});
    },

    //

    __end__: null

  });
</script>
