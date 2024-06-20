package org.msh.etbm.commons.models.impl;

import org.graalvm.polyglot.Value;
import org.msh.etbm.commons.models.data.Field;
import org.msh.etbm.commons.models.data.Model;
import org.springframework.validation.Errors;
import org.springframework.validation.MapBindingResult;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Created by rmemoria on 5/7/16.
 */
public class ValidationContext {
    private Model model;
    private Value jsModel;
    private Errors errors;
    private Map<String, Object> doc;

    /**
     * The JS object containing a copy of the doc, to be used in JS execution
     */
    private Map<String, Object> docBinding;

    /**
     * The record ID, if available
     */
    private UUID id;


    public ValidationContext(Model model, Value jsModel, Map<String, Object> doc, UUID id) {
        this.model = model;
        this.jsModel = jsModel;
        this.doc = doc;
        this.errors = new MapBindingResult(doc, model.getName());
        this.id = id;
    }

    /**
     * Create a context for the field of the model
     * @param field instance of {@link Field} in the model
     * @return instance of {@link FieldContext}
     */
    public FieldContext createFieldContext(Field field) {
        Value fields = jsModel.getMember("fields");
        Value jsField = fields.getMember(field.getName());
        FieldContext fieldContext = new FieldContext(this, field, jsField);

        return fieldContext;
    }

    /**
     * Get the document binding representing the document, to be used in JS engine
     * @return
     */
    public Map<String, Object> getDocBinding() {
        if (docBinding == null) {
            docBinding = new HashMap<>();
            docBinding.putAll(doc);
        }

        return docBinding;
    }

    public Model getModel() {
        return model;
    }

    public Value getJsModel() {
        return jsModel;
    }

    public Errors getErrors() {
        return errors;
    }

    public Map<String, Object> getDoc() {
        return doc;
    }

    public UUID getId() {
        return id;
    }

}
