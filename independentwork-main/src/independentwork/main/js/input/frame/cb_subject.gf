<%@ page import="independentwork.main.model.sys.FD_Const; jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>
%{-- 



========================================================================= --}%

<jc:include url="js/input/frame/cb_sgrid.gf"/>
<gf:attr name="daoname" value="Subject/list"/>
<gf:attr name="title" value="Предметы"/>

<gf:groovy id="loadData">
  <%
    GfFrame gf = args.gf
    GfAttrs a = gf.attrs
    //
    SGridDataStore st = gf.createSGridStore(a.daoname)
    st.load()
    a.store = st
  %>
</gf:groovy>



<g:javascript id="gridColumns" method="gridColumns" params="b, res">
    res.push(
            b.column('name', {tdCls: "td-wrap", flex: 1})
    );
</g:javascript>

%{-- =========================================================================

  Конфигурация фильтров

--}%
<g:javascript id="gridFilters" method="gridFilters" params="b, res">
    res.push(

    );
</g:javascript>

%{-- =========================================================================

  Конфигурация сортировки

--}%
<g:javascript id="gridOrderBy" method="gridOrderBy" params="b, res">
    res.push(

    );
</g:javascript>