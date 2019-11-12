package org.fundacionjala.core.api;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import io.restassured.response.Response;

import org.fundacionjala.core.ScenarioContext;

public final class DynamicIdHelper {

    private DynamicIdHelper() {
    }

    public static String buildEndpoint(final ScenarioContext context, final String endPoint) {
        String[] endPointSplit = endPoint.split("/");
        for (int i = 0; i < endPointSplit.length; i++) {
            Pattern pattern = Pattern.compile("(?<=\\{)(.*?)(?=\\})");
            Matcher matcher = pattern.matcher(endPointSplit[i]);
            if (matcher.find()) {
                endPointSplit[i] = getElementResponse(context, matcher.group(1));
            }
        }
        return String.join("/", endPointSplit);
    }

    private static String getElementResponse(final ScenarioContext context, final String element) {
        String[] elementSplit = element.split("\\.");
        Response response = (Response) context.get(elementSplit[0]);
        return response.jsonPath().getString(elementSplit[1]);
    }

    public static String replaceIds(final ScenarioContext context, final String body) {
        if (!body.contains("(")) {
            return body;
        }
        StringBuffer result = new StringBuffer();
        Pattern pattern = Pattern.compile("(?<=\\()(.*?)(?=\\))");
        Matcher matcher = pattern.matcher(body);
        while (matcher.find()) {
            matcher.appendReplacement(result, getElementResponse(context, matcher.group()));
        }
        matcher.appendTail(result);
        return result.toString().replaceAll("[\\(\\)]", "");
    }

}
