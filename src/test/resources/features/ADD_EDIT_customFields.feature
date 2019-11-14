Feature: CustomFields

  Background:
    Given I use the "trello" service and the "owner" account
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
    Scenario: Add CheckBox custom field
      When I send a "POST" request to "/customFields" with json body
      """
      {
        "idModel": "(L.idBoard)",
        "modelType": "board",
        "name": "checkBox Field",
        "type": "checkbox",
        "pos": "top",
        "display": {
            "cardFront": true
        }
      }
      """
      And I save the response as "C"
      Then I validate the response has status code 200
      And I validate the response contains "name" equals "checkBox Field"
      And I validate the response contains "type" equals "checkbox"
      And I send a "DELETE" request to "/boards/{B.id}"