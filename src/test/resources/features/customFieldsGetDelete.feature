Feature: CustomFields

  Background:
    Given I use the "trello" service and the "user1" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board1 for Custom Fields"
    }
    """
    And I save the response as "B"
    And I save the request endpoint for deleting
    And I send a "POST" request to "/boards/{B.id}/boardPlugins" with json body
      """
      {
      "idPlugin":"56d5e249a98895a9797bebb9"
      }
      """
    And I save the response as "L"
    And I send a "POST" request to "/customFields" with json body
      """
      {
        "idModel": "(L.idBoard)",
        "modelType": "board",
        "name": "dropdown",
        "type": "list",
        "pos": 16384,
        "display": {
            "cardFront": false
        },
        "options": [
            {
                "value": {
                    "text": "first option"
                },
                "color": "red",
                "pos": 1024
            },
            {
                "value": {
                    "text": "second option"
                },
                "color": "blue",
                "pos": 2048
            }
        ]
      }
      """
    And I save the response as "C"

  @cleanData
  Scenario: Get all options from a custom field
    When I send a "GET" request to "/customField/{C.id}/options"
    Then I validate the response has status code 200
    And I validate the response contains "color" equals "[red, blue]"

  @cleanData
  Scenario: Get options from a specific custom field ID
    When I send a "GET" request to "/customField/{C.id}/options"
    And I save the response as "O"
    And I send a "GET" request to "/customField/{C.id}/options/{O._id[0]}"
    Then I validate the response has status code 200
    And I validate the response contains "color" equals "red"

  @cleanData
  Scenario: Delete an options from a specific custom field ID
    When I send a "GET" request to "/customField/{C.id}/options"
    And I save the response as "O"
    And I send a "DELETE" request to "/customField/{C.id}/options/{O._id[0]}"
    Then I validate the response has status code 200
