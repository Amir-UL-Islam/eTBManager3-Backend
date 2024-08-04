package org.msh.etbm.test.commons.forms;

import org.graalvm.polyglot.Context;
import org.graalvm.polyglot.Value;
import org.junit.Test;
import org.msh.etbm.commons.forms.data.Form;
import org.msh.etbm.commons.forms.impl.JavaScriptFormGenerator;
import org.msh.etbm.commons.forms.impl.JsonFormParser;
import org.msh.etbm.test.AuthenticatedTest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;

import javax.script.Invocable;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

import java.io.IOException;

import static org.junit.Assert.assertNotNull;

/**
 * Test the generation of java script code to be sent to the client side
 *
 * Created by rmemoria on 26/7/16.
 */
public class JavaScriptFormGenTest extends AuthenticatedTest {

    @Autowired
    JavaScriptFormGenerator javaScriptFormGenerator;

    @Test
    public void test() throws IOException {
        ClassPathResource resource = new ClassPathResource("/test/forms/parse-test.json");
        JsonFormParser p = new JsonFormParser();
        Form frm = p.parse(resource.getInputStream());

        String script = javaScriptFormGenerator.generate(frm, "newSchema");

        System.out.println(script);

        try (Context context = Context.create("js")) {
            // compile the script to test if it was generated correctly
            context.eval("js", script);

            Value newSchemaFunction = context.getBindings("js").getMember("newSchema");
            if (newSchemaFunction == null) {
                throw new RuntimeException("Function newSchema not found in script");
            }

            Value res = newSchemaFunction.execute();
            assertNotNull(res.getMember("defaultProperties"));
            assertNotNull(res.getMember("controls"));
        }
    }

    private void assertNotNull(Object obj) {
        if (obj == null) {
            throw new AssertionError("Object should not be null");
        }
    }
}
