package org.msh.etbm.commons.models.impl;

import org.graalvm.polyglot.Context;
import org.graalvm.polyglot.Value;
import org.msh.etbm.commons.Messages;
import org.msh.etbm.commons.models.data.Validator;
import org.springframework.validation.Errors;

import java.util.List;
import java.util.Map;

/**
 * Execute a list of validators. Used both in model custom validators and field custom validators
 * Created by rmemoria on 6/7/16.
 */
public class CustomValidatorsExecutor {

    /**
     * Execute the custom validators
     * @param fieldName the field name (null if in model)
     * @param validators list of {@link Validator} objects
     * @param jsValidators JavaScript object containing the compiled objects
     * @param doc the document to be validated in JS format
     * @param errors the object to receive the errors
     * @param messages the messages object to evaluate error messages
     * @return true if validators were successfully executed
     */
    public static boolean execute(String fieldName, List<Validator> validators,
                                  Value jsValidators, Map<String, Object> doc, Errors errors,
                                  Messages messages) {
        int index = 0;
        boolean success = true;

        try (Context context = Context.create()) {
            Value jsDoc = context.asValue(doc);

            for (Validator validator : validators) {
                Value func = jsValidators.getMember("v" + index);
                boolean res = func.execute(jsDoc).asBoolean();
                if (!res) {
                    String msg = messages != null ? messages.eval(validator.getMessage()) : validator.getMessage();

                    if (fieldName != null) {
                        errors.rejectValue(fieldName, null, msg);
                    } else {
                        errors.reject(null, msg);
                    }
                    success = false;
                }
                index++;
            }
        } catch (Exception e) {
            throw new RuntimeException("Error executing custom validators", e);
        }

        return success;
    }
}
