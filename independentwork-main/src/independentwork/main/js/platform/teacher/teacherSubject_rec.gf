<%@ page import="jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{--

Редактор для записи

========================================================================= --}%


<jc:include url="js/frame/edit_rec.gf"/>
<gf:attr name="daoname" value="SubjectUser/updater"/>

%{-- ========================================================================= --}%
<g:javascript>
    th.width = 500;
    //
    th.items = [
        b.input2("subject",{jsclass: "Cb_Subject"})
    ];
</g:javascript>
