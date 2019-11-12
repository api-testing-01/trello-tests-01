package org.fundacionjala.core;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ScenarioContext {

    private Map<String, Object> map;
    private List<String> endpoints;

    public ScenarioContext() {
        map = new HashMap<>();
        endpoints = new ArrayList<>();
    }

    public Object get(final String key) {
        return map.get(key);
    }

    public void set(final String key, final Object response) {
        map.put(key, response);
    }

    public void addEndpoint(final String endpoint) {
        endpoints.add(endpoint);
    }

    public List<String> getEndpoints() {
        return endpoints;
    }
}
