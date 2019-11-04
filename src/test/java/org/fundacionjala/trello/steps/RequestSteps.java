package org.fundacionjala.trello.steps;

import java.util.Map;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.json.simple.JSONObject;
import org.testng.Assert;

import org.fundacionjala.trello.EndpointHelper;
import org.fundacionjala.trello.JsonHelper;
import org.fundacionjala.trello.RequestManager;
import org.fundacionjala.trello.RequestSpecFactory;
import org.fundacionjala.trello.ScenarioContext;

public class RequestSteps {

    private RequestSpecification requestSpecification;
    private Response response;
    private ScenarioContext context;

    public RequestSteps(final ScenarioContext context) {
        this.context = context;
    }

    @Given("I use the {string} service and the {string} account")
    public void iUseTheService(final String serviceName, final String accountName) {
        requestSpecification = RequestSpecFactory.getRequestSpec(serviceName, accountName);
    }

    @Given("I send a {string} request to {string} with json body")
    public void iSendARequestToWithJsonBody(final String httpMethod, final String endpoint,
                                            final String jsonBody) {
        if ("POST".equalsIgnoreCase(httpMethod)) {
            response = RequestManager.post(requestSpecification,
                    EndpointHelper.buildEndpoint(context, endpoint),
                    jsonBody);
        } else if ("PUT".equalsIgnoreCase(httpMethod)) {
            response = RequestManager.put(requestSpecification,
                    EndpointHelper.buildEndpoint(context, endpoint),
                    jsonBody);
        } else {
            response = RequestManager.patch(requestSpecification,
                    EndpointHelper.buildEndpoint(context, endpoint),
                    jsonBody);
        }
    }

    @Given("I send a {string} request to {string} with json file {string}")
    public void iSendARequestToWithJsonFile(final String httpMethod, final String endpoint,
                                            final String jsonPath) {
        JSONObject jsonBody = JsonHelper.getJsonObject("src/test/resources/".concat(jsonPath));
        if ("POST".equalsIgnoreCase(httpMethod)) {
            response = RequestManager.post(requestSpecification,
                    EndpointHelper.buildEndpoint(context, endpoint),
                    jsonBody);
        } else {
            response = RequestManager.put(requestSpecification,
                    EndpointHelper.buildEndpoint(context, endpoint),
                    jsonBody);
        }
    }

    @When("I send a GET request to {string}")
    public void iSendAGETRequestTo(final String endpoint) {
        response = RequestManager.get(requestSpecification,
                EndpointHelper.buildEndpoint(context, endpoint));
    }

    @Given("I send a DELETE request to {string}")
    public void iSendARequestTo(final String endpoint) {
        response = RequestManager.delete(requestSpecification,
                EndpointHelper.buildEndpoint(context, endpoint));
    }

    @Then("I validate the response has status code {int}")
    public void iValidateTheResponseHasStatusCode(int expectedStatusCode) {
        int statusCode = response.getStatusCode();
        Assert.assertEquals(statusCode, expectedStatusCode);
    }

    @And("I validate the response contains {string} equals {string}")
    public void iValidateTheResponseContainsEquals(final String attribute, final String expectedValue) {
        String actualProjectName = response.jsonPath().getString(attribute);
        Assert.assertEquals(actualProjectName, expectedValue);
    }

    @And("I save the response as {string}")
    public void iSaveTheResponseAs(final String key) {
        context.set(key, response);
    }

    @Given("I send a {string} request to {string}")
    public void iSendARequestTo(final String httpMethod, final String endpoint, final Map<String, String> body) {
        if ("POST".equalsIgnoreCase(httpMethod)) {
            response = RequestManager.post(requestSpecification,
                    EndpointHelper.buildEndpoint(context, endpoint),
                    body);
        } else {
            response = RequestManager.put(requestSpecification,
                    EndpointHelper.buildEndpoint(context, endpoint),
                    body);
        }
    }
}
