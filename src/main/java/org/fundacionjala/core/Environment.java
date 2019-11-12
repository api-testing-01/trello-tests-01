package org.fundacionjala.core;

import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;
import org.json.simple.JSONObject;

public final class Environment {

    private static Environment instance = new Environment();

    private DocumentContext jsonContext;

    private Environment() {
        String configJsonPath = "config.json";
        JSONObject jsonObject = JsonHelper.getJsonObject(configJsonPath);
        jsonContext = JsonPath.parse(jsonObject);
    }

    public static Environment getInstance() {
        return instance;
    }

    public String getValue(final String keyJsonPath) {
        return jsonContext.read(keyJsonPath);
    }

}
