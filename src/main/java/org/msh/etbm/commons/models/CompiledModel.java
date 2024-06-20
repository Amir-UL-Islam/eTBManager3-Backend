package org.msh.etbm.commons.models;

import org.graalvm.polyglot.Context;
import org.graalvm.polyglot.Value;
import org.msh.etbm.commons.models.data.Model;
import org.msh.etbm.commons.models.impl.*;
import org.springframework.validation.Errors;

import java.util.Map;

/**
 * {@link CompiledModel} is a class that contains a {@link Model} instance and its compiled
 * JavaScript code. The JavaScript code is compiled and used during validation of a document
 * (conversion and validation phases).
 * <p/>
 * {@link CompiledModel} can be cached and reused by many simultaneous requests.
 *
 * Created by rmemoria on 6/7/16.
 */
public class CompiledModel {

    private Model model;
    private Value jsModel;

    public CompiledModel(Model model) {
        this.model = model;
        if (model.getName() == null) {
            throw new ModelException("Model name must be informed");
        }
    }

    /**
     * Validate the given document against the model
     * @param doc the document to check
     * @return
     */
    public ValidationResult validate(Map<String, Object> doc, ModelResources modelResources) {
        ValidationContext context = createContext(doc);

        // convert the values to the final value
        ModelConverter converter = new ModelConverter();
        Map<String, Object> newdoc = converter.convert(context);

        // check if there are conversion errors
        if (context.getErrors().getErrorCount() > 0) {
            return new ValidationResult(context.getErrors(), newdoc);
        }

        // call validation
        ModelValidator validator = new ModelValidator();
        context = createContext(newdoc);
        Errors errors = validator.validate(context, newdoc, modelResources);

        return new ValidationResult(errors, newdoc);
    }


    public Value getJsModel() {
        if (jsModel == null) {
            generateJsModel();
        }

        return jsModel;
    }

    protected void generateJsModel() {
        ModelScriptGenerator gen = new ModelScriptGenerator();
        String script = gen.generate(model);

        Value res = compileScript(script);
        jsModel = res;
    }

    /**
     * Compile the JS script and return an object to interact with it. The script must be a function
     * @param script the script in string format
     * @return the object to interact with the script
     */
    private Value compileScript(String script) {
        try (Context context = Context.create("js")) {
            context.eval("js", script);

            String funcName = ModelScriptGenerator.modelFunctionName(model);
            return context.getBindings("js").getMember(funcName);
        } catch (Exception e) {
            throw new ModelException(e);
        }
    }

    public ValidationContext createContext(Map<String, Object> doc) {
        return new ValidationContext(model, getJsModel(), doc, null);
    }

    public Model getModel() {
        return model;
    }
}
