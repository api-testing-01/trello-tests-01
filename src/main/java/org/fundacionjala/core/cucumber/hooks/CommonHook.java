package org.fundacionjala.core.cucumber.hooks;

import java.util.List;

import io.cucumber.java.After;
import io.restassured.specification.RequestSpecification;

import org.fundacionjala.core.api.RequestManager;
import org.fundacionjala.core.ScenarioContext;

public class CommonHook {

    private ScenarioContext context;

    public CommonHook(final ScenarioContext context) {
        this.context = context;
    }

    @After(value = "@cleanData")
    public void afterScenario() {
        RequestSpecification requestSpec = (RequestSpecification) context.get("REQUEST_SPEC");
        List<String> endpoints = context.getEndpoints();
        for (String endpoint : endpoints) {
            RequestManager.delete(requestSpec, endpoint);
        }
    }
}
