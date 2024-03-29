package org.fundacionjala.core.cucumber.steps;

import java.util.Map;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.fundacionjala.core.Environment;
import org.json.simple.JSONObject;
import org.testng.Assert;

import org.fundacionjala.core.JsonHelper;
import org.fundacionjala.core.ScenarioContext;
import org.fundacionjala.core.api.DynamicIdHelper;
import org.fundacionjala.core.api.RequestManager;

public class RequestSteps {

    private Response response;
    private ScenarioContext context;
    private static final Environment ENV = Environment.getInstance();

    public RequestSteps(final ScenarioContext context) {
        this.context = context;
    }

    @Given("I send a {string} request to {string} with json body")
    public void iSendARequestToWithJsonBody(final String httpMethod, final String endpoint,
                                            final String jsonBody) {
        RequestSpecification requestSpecification = (RequestSpecification) context.get("REQUEST_SPEC");
        String builtEndpoint = DynamicIdHelper.buildEndpoint(context, endpoint);
        response = RequestManager.doRequest(httpMethod, requestSpecification, builtEndpoint,
                DynamicIdHelper.replaceIds(context, jsonBody));
        context.set("LAST_ENDPOINT", builtEndpoint);
        context.set("LAST_RESPONSE", response);
    }

    @Given("I send a {string} request to {string} with json file {string}")
    public void iSendARequestToWithJsonFile(final String httpMethod, final String endpoint,
                                            final String jsonPath) {
        RequestSpecification requestSpecification = (RequestSpecification) context.get("REQUEST_SPEC");
        JSONObject jsonBody = JsonHelper.getJsonObject("src/test/resources/".concat(jsonPath));
        String builtEndpoint = DynamicIdHelper.buildEndpoint(context, endpoint);
        response = RequestManager.doRequest(httpMethod, requestSpecification, builtEndpoint,
                DynamicIdHelper.replaceIds(context, jsonBody.toJSONString()));
        context.set("LAST_ENDPOINT", builtEndpoint);
        context.set("LAST_RESPONSE", response);
    }

    @Given("I send a {string} request to {string} with datatable")
    public void iSendARequestTo(final String httpMethod, final String endpoint, final Map<String, String> body) {
        RequestSpecification requestSpecification = (RequestSpecification) context.get("REQUEST_SPEC");
        String builtEndpoint = DynamicIdHelper.buildEndpoint(context, endpoint);
        response = RequestManager.doRequest(httpMethod, requestSpecification, builtEndpoint, body);
        context.set("LAST_ENDPOINT", builtEndpoint);
        context.set("LAST_RESPONSE", response);
    }

    @When("I send a {string} request to {string}")
    public void iSendARequestTo(final String httpMethod, final String endpoint) {
        RequestSpecification requestSpecification = (RequestSpecification) context.get("REQUEST_SPEC");
        String builtEndpoint = DynamicIdHelper.buildEndpoint(context, endpoint);
        response = RequestManager.doRequest(httpMethod, requestSpecification, builtEndpoint);
        context.set("LAST_ENDPOINT", builtEndpoint);
        context.set("LAST_RESPONSE", response);
    }

    @When("I add {string} as admin member to board with id {string}")
    public void iAddAsMemberToBoardWithId(final String userName, final String boardId) {
        String userNameProperty = ENV.getPropertyByService("trello", userName);
        String getEndpoint = String.format("/members/%s", userNameProperty);
        iSendARequestTo("GET", getEndpoint);
        String idMember = response.jsonPath().getString("id");
        String putEndpoint = String.format("/boards/%s/members/%s", boardId, idMember);
        iSendARequestToWithJsonBody("PUT", putEndpoint, "{\"type\": \"admin\"}");
        context.set("LAST_ENDPOINT", putEndpoint);
        context.set("LAST_RESPONSE", response);
    }

    @When("I send a GET request to {string} with urlParam")
    public void iSendARequestToWithUrlParam(final String endpoint, final Map<String, String> urlParam) {
        RequestSpecification requestSpecification = (RequestSpecification) context.get("REQUEST_SPEC");
        String builtEndpoint = DynamicIdHelper.buildEndpoint(context, endpoint);
        response = RequestManager.doRequest(requestSpecification, builtEndpoint, urlParam);
        context.set("LAST_ENDPOINT", builtEndpoint);
        context.set("LAST_RESPONSE", response);
    }

    @Then("I validate the response has status code {int}")
    public void iValidateTheResponseHasStatusCode(int expectedStatusCode) {
        int statusCode = response.getStatusCode();
        Assert.assertEquals(statusCode, expectedStatusCode);
    }

    @And("I validate the response contains {string} equals {string}")
    public void iValidateTheResponseContainsEquals(final String attribute, final String expectedValue) {
        String expectedValue1 = DynamicIdHelper.buildEndpoint(context, expectedValue);
        String actualProjectName = response.jsonPath().getString(attribute);
        Assert.assertEquals(actualProjectName, expectedValue1);
    }

    @And("I save the response as {string}")
    public void iSaveTheResponseAs(final String key) {
        context.set(key, response);
    }

    @And("I save the request endpoint for deleting")
    public void iSaveTheRequestEndpointForDeleting() {
        String lastEndpoint = (String) context.get("LAST_ENDPOINT");
        String lastResponseId = ((Response) context.get("LAST_RESPONSE")).jsonPath().getString("id");
        String finalEndpoint = String.format("%s/%s", lastEndpoint, lastResponseId);
        context.addEndpoint(finalEndpoint);
    }
}
