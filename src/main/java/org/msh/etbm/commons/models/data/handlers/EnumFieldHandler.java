package org.msh.etbm.commons.models.data.handlers;

import org.msh.etbm.commons.Item;
import org.msh.etbm.commons.Messages;
import org.msh.etbm.commons.models.ModelException;
import org.msh.etbm.commons.models.data.fields.AddressField;
import org.msh.etbm.commons.models.data.fields.EnumField;
import org.msh.etbm.commons.models.impl.FieldContext;
import org.msh.etbm.commons.objutils.ObjectUtils;
import org.msh.etbm.db.MessageKey;
import org.msh.etbm.services.admin.AddressData;
import org.msh.etbm.services.admin.AddressEditData;
import org.msh.etbm.services.admin.admunits.data.AdminUnitData;

import java.util.Map;
import java.util.UUID;


/**
 * Created by rmemoria on 8/8/16.
 */
public class EnumFieldHandler extends SingleFieldHandler<EnumField> {

    @Override
    protected Object convertValue(EnumField field, FieldContext fieldContext, Object value) {
        if (value == null) {
            return null;
        }

        Class<? extends Enum> enumClass = field.resolveEnumClass();

        if (enumClass.isAssignableFrom(value.getClass())) {
            return value;
        }

        if (value instanceof String) {
            String key = (String)value;
            Enum[] vals = enumClass.getEnumConstants();

            for (Enum val: vals) {
                if (val.toString().equals(key)) {
                    return val;
                }
            }
        }

        registerConversionError(fieldContext);
        return null;
    }

    @Override
    protected void validateValue(EnumField field, FieldContext context, Object value) {
        if (value instanceof Enum) {
            return;
        }

        if (!(value instanceof String)) {
            context.rejectValue(Messages.NOT_VALID, null);
        }

        if (field.getEnumClass() == null) {
            throw new ModelException("Field enumeration class not available");
        }

        Enum[] vals = field.resolveEnumClass().getEnumConstants();
        String key = (String)value;

        boolean found = false;
        for (Enum val: vals) {
            if (val.toString().equals(key)) {
                found = true;
                break;
            }
        }

        if (!found) {
            context.rejectValue(Messages.NOT_VALID, null);
        }
    }

    @Override
    public Map<String, Object> mapFieldsToSave(EnumField field, Object value) {
        Map<String, Object> res = super.mapFieldsToSave(field, value);
        assert res.size() == 1 : "Expected one single value";

        String key = res.keySet().iterator().next();

        // convert enum to
        Object val = res.get(key);
        if (val != null) {
            int index = ((Enum)val).ordinal();
            res.put(key, index);
        }

        return res;
    }

    @Override
    public Object readSingleValueFromDb(EnumField field, Object value) {
        if (value == null) {
            return null;
        }

        Enum e;

        if (value instanceof Integer) {
            Class<? extends Enum> enumClass = field.resolveEnumClass();
            e = enumClass.getEnumConstants()[(Integer) value];
            return e;
        }

        throw new RuntimeException("Check enum field handler");
    }
}
