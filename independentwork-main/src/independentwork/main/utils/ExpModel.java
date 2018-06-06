package independentwork.main.utils;

import jandcode.app.*;
import jandcode.dbm.*;

/**
 * Модель.
 * Содержит ссылку на зарегистрированную модель dbm.
 */
public class ExpModel extends Comp {

    private Model model;

    public Model getModel() {
        return model;
    }

    public void setModel(Model model) {
        this.model = model;
        this.setName(model.getName());
    }
}
