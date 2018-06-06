<%@ page import="independentwork.main.model.sys.FD_Const; jandcode.utils.UtLang; jandcode.web.*; jandcode.dbm.*; jandcode.dbm.data.*; jandcode.wax.core.utils.gf.*" %>

%{-- id записи. Если =0, то новая запись --}%
<gf:attr name="recId" type="long" ext="true"/>

%{--данные записи по умолчанию. Накладываются на загруженную или новую запись--}%
<gf:attr name="recData" type="map" ext="true"/>

%{--имя dao для чтения/записи--}%
<gf:attr name="daoname" type="string" value="AuthUser/updater"/>

%{--метод для записи. По умолчанию равен режиму mode (ins/upd)--}%
<gf:attr name="daomethod" type="string"/>

<gf:groovy>
  <%
    // получаем ссылку на фрейм
    GfFrame gf = args.gf
    // получаем ссылку на атрибуты
    def a = gf.attrs

    // определяем режим
    a.mode = "ins"
    if (a.recId != 0) {
      a.mode = "upd"
    }

    // определяем метод записи
    if (a.daomethod == "") {
      a.daomethod = a.mode
    }

    // title
    if (a.mode == "ins") {
      a.title = UtLang.t("Новая запись")
    } else {
      a.title = UtLang.t("Редактирование записи")
    }

    // грузим запись
    DataRecord rec
    if (a.mode == "ins") {
      rec = gf.daoinvoke(a.daoname, "newRec")
    } else {
      rec = gf.daoinvoke(a.daoname, "loadRec", a.recId)
    }

    rec.setValue("authUserRole", FD_Const.AuthUserRole_learned)
    rec.setValue("authUserType", FD_Const.AuthUserType_user)

    a.store = rec

    // данные по умолчанию с клиента
    Map recData = a.recData
    if (recData.size() > 0) {
      rec.setValues(recData)
      gf.resolveDicts(rec)
    }



  %>
</gf:groovy>

<g:javascript>
  th.layout = b.layout('table', {colspan: 2});
  th.shower = "dialog";
  th.width = 520;

  th.items = [
    b.input2("login"),
    th.i1 = b.input2("name"),
    th.i2 = b.input2("fullName"),
    b.datalabel2("authUserRole"),
    b.input2("locked")
  ];
  //
  if (th.mode == "ins") {
    th.items.push([
      b.delim(UtLang.t("Пароль")),
      b.input2("passwd"),
      b.input2("passwd2")
    ]);
  }
  th.items.push([
    b.delim(UtLang.t("Контактные данные")),
    b.input2("email", {width: "medium"}),
    b.input2("phoneNumber", {width: "medium"})
  ])

  Jc.tofi.syncInputLangstring(th.i1[1], th.i2[1]);

</g:javascript>


<g:javascript id="onOk" method="onOk">
  th.controlToData();
  if (th.mode == "ins") {
    return th.onIns();
  } else {
    return th.onUpd();
  }
</g:javascript>

<g:javascript id="onIns" method="onIns">

  th.recId = Jc.daoinvoke("AuthUser/updater", "insStudent", [th.store]);
  th.store.set("id", th.recId);
</g:javascript>

<g:javascript id="onUpd" method="onUpd">
  Jc.daoinvoke("AuthUser/updater", "upd", [th.store]);
</g:javascript>