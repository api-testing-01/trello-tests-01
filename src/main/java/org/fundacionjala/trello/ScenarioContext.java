package org.fundacionjala.trello;

import java.util.HashMap;
import java.util.Map;

import io.restassured.response.Response;

public class ScenarioContext {

    private Map<String, Response> map;

    public ScenarioContext() {
        map = new HashMap<>();
    }

    public Response get(final String key) {
        return map.get(key);
    }

    public void set(final String key, final Response response) {
        map.put(key, response);
    }
}
