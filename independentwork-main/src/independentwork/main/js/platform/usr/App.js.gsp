<%@ page import="jandcode.lang.*" %>
<script type="text/javascript">
  Ext.define("Jc.usr.App", {
    extend: "Jc.ExpBaseApp",

    title: UtLang.t("Управление пользователями"),
    logoWidth: 320,

    createAppMenu: function() {
      var mm = [
        Jc.action({text: UtLang.t('Меню'), icon: "home", onExec: this.toolsMenu}),
        '->',
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
        Jc.showFrame({frame: 'Jc.usr.Home', id: true});
      }
    },

    toolsMenu: function() {
      Jc.showFrame({frame: 'js/usr/tools_menu.gf', id: true});
    },

    //

    __end__: null

  });
</script>
