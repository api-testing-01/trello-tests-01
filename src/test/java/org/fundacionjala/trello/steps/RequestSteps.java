package org.fundacionjala.trello.steps;

import io.cucumber.java.en.Given;
import io.restassured.specification.RequestSpecification;

import org.fundacionjala.core.ScenarioContext;
import org.fundacionjala.trello.RequestSpecFactory;

public class RequestSteps {

    private ScenarioContext context;

    public RequestSteps(final ScenarioContext context) {
        this.context = context;
    }

    @Given("I use the {string} service and the {string} account")
    public void iUseTheService(final String serviceName, final String accountName) {
        RequestSpecification requestSpecification = RequestSpecFactory.getRequestSpec(serviceName, accountName);
        context.set("REQUEST_SPEC", requestSpecification);
    }
}
