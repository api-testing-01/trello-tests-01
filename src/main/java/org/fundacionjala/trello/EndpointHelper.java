package org.fundacionjala.trello;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class EndpointHelper {

    private EndpointHelper() {
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
        return context.get(elementSplit[0]).jsonPath().getString(elementSplit[1]);
    }

}
