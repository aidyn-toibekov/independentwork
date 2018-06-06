package independentwork.main.model.auth

import jandcode.app.*
import jandcode.utils.*
import jandcode.utils.rt.*

class UtPriv {

    protected HashMapNoCase<Rt> privRt

    protected String privName = "default";

    protected App app;

    protected Rt rootPrivRt

    public UtPriv(App app) {
        this.app = app
    }

    protected Rt getRootPrivRt() {
        String rtpath = "auth/priv/" + privName
        if (rootPrivRt == null)
            rootPrivRt = app.getRt().findChild(rtpath);
    }

    public Rt getPrivRt(String name) {
        if (privRt == null)
            loadPrivs()

        return privRt.get(name)
    }

    protected void loadPrivs() {
        privRt = new HashMapNoCase<Rt>()
        Rt rt = getRootPrivRt()
        if (rt == null) {
            return;
        }
        internal_loadPrivs(rt);
    }

    private void internal_loadPrivs(Rt rt) {
        Rt x = rt.findChild("priv");
        if (x == null) {
            return;
        }
        for (Rt x1 : x.getChilds()) {
            privRt.put(x1.getName(), x1)
            internal_loadPrivs(x1);
        }
    }

    public boolean isAccessLevRequired(String privName) {
        Rt rt = getPrivRt(privName)
        if (rt == null)
            throw new RuntimeException(UtLang.t("Не найдена привилегия с названием {0}", privName));

        IRtAttr attr = findAttr(rt, "reqAccessLev")
        if (attr == null)
            return false
        else
            return UtCnv.toBoolean(attr.getValue())
    }

    private IRtAttr findAttr(Rt rt, String attrName) {
        for (IRtAttr attr : rt.getAttrs()) {
            if (attr.getName().equalsIgnoreCase(attrName))
                return attr
        }
        return null
    }
}
