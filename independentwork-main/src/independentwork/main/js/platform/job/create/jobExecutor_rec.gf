<%@ page import="jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--

Редактор для записи

========================================================================= --}%


<jc:include url="js/frame/edit_rec.gf"/>
<gf:attr name="daoname" value="JobExecutor/updater"/>

%{-- ========================================================================= --}%
<g:javascript>
    th.width = 500;
    //
    th.items = [
        b.label(UtLang.t("Обучающиеся")),
        b.input("executor",{jsclass: "Cb_AuthUserLearner", title:"Обучающиеся"})
    ];
</g:javascript>
