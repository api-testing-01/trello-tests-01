Feature: Boundary and negative scenarios for CustomFields

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

  @cleanData
  Scenario: Add CheckBox custom field with invalid position
    When I send a "POST" request to "/customFields" with json body
    """
     {
       "idModel": "(L.idBoard)",
       "modelType": "board",
       "name": "checkBox Field",
       "type": "checkbox",
       "pos": "middle",
       "display": {
           "cardFront": true
       }
     }
     """
    And I save the response as "C"
    Then I validate the response has status code 400
    And I validate the response contains "message" equals "Invalid position."
    And I validate the response contains "error" equals "ERROR"

  @cleanData
  Scenario: Add custom field without type
    When I send a "POST" request to "/customFields" with json body
      """
      {
        "idModel": "(L.idBoard)",
        "modelType": "board",
        "name": "custom Field",
        "pos": "16384",
        "display": {
            "cardFront": true
        }
      }
      """
    And I save the response as "C"
    Then I validate the response has status code 400
    And I validate the response contains "message" equals "Unsupported custom field type"

  @cleanData
  Scenario: Add two CheckBox custom field with same position (2nd will be relocated automatically)
    When I send a "POST" request to "/customFields" with json body
    """
     {
       "idModel": "(L.idBoard)",
       "modelType": "board",
       "name": "checkBox Field 1",
       "type": "checkbox",
       "pos": "16384",
       "display": {
           "cardFront": true
       }
     }
     """
    And I send a "POST" request to "/customFields" with json body
    """
     {
       "idModel": "(L.idBoard)",
       "modelType": "board",
       "name": "checkBox Field 2",
       "type": "checkbox",
       "pos": "16384",
       "display": {
           "cardFront": true
       }
     }
     """
    And I save the response as "C"
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "checkBox Field 2"
    And I validate the response contains "pos" equals "32768"

  @cleanData
  Scenario: Add two CheckBox custom field with same name and type
    When I send a "POST" request to "/customFields" with json body
    """
     {
       "idModel": "(L.idBoard)",
       "modelType": "board",
       "name": "checkBox Field 1",
       "type": "checkbox",
       "pos": "16384",
       "display": {
           "cardFront": true
       }
     }
     """
    And I send a "POST" request to "/customFields" with json body
    """
     {
       "idModel": "(L.idBoard)",
       "modelType": "board",
       "name": "checkBox Field 1",
       "type": "checkbox",
       "pos": "16384",
       "display": {
           "cardFront": true
       }
     }
     """
    And I save the response as "C"
    Then I validate the response has status code 409
    And I validate the response contains "message" equals "A custom field with that name and type already exists"
    And I validate the response contains "error" equals "CUSTOM_FIELD_DUPLICATE_FIELD"

  @cleanData
  Scenario: Custom field other than List does not have Options
    When I send a "POST" request to "/customFields" with json body
      """
      {
        "idModel": "(L.idBoard)",
        "modelType": "board",
        "name": "text Field",
        "type": "text",
        "pos": "16384",
        "display": {
            "cardFront": true
        }
      }
      """
    And I save the response as "C"
    And I send a "GET" request to "/customFields/{C.id}/options"
    Then I validate the response has status code 404
    And I validate the response contains "message" equals "Custom fields of type text have no options"
    And I validate the response contains "error" equals "CUSTOM_FIELD_NOT_LIST_TYPE"
