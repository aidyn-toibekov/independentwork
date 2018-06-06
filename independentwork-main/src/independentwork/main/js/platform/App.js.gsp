<%@ page import="jandcode.lang.*" %>
<script type="text/javascript">
  Ext.define("Jc.platform.App", {
    extend: "Jc.ExpBaseApp",

    title: UtLang.t("Самостоятельная работа обучаемого"),

    logoWidth: 400,

    createAppMenu: function() {
      var mm = [
          '->',
        Jc.menu({text: UtLang.t('Помощь'), icon: "home", items: [
          Jc.action({text: 'О программе...', icon: "info", scope: this, onExec: this.about})
        ]}),

        '-',
        this.createModelButton(),
        this.createLangButton(),
        this.createUserButton(),
        this.createLogoutButton(),
        '-',
        this.createCloseButton()
      ];
      return mm;
    },

    //

    home: function() {
      if (Jc.ini.userInfo.guest) {
        Jc.showFrame({frame: 'Jc.auth.LoginPage', id: true});
      } else {
        Jc.app.toolsMenu();
        Jc.showFrame({frame: 'js/platform/home.gf', id: true});
      }
    },

    toolsMenu: function() {
      Jc.showFrame({frame: 'js/platform/tools_menu.gf', id: true});
    },

    help: function() {
      Jc.showFrame({
        frame: "Jc.frame.HtmlView", id: 'app-frame-help',
        title: 'Помощь',
        url: Jc.url('help/index.html')
      });
    },

    about: function() {
      Jc.showFrame({frame: "js/platform/about.gf"});
    },



    //

    __end__: null

  });
</script>
