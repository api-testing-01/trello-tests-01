Feature: Cards

  Background:
    Given I use the "trello" service and the "owner" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board for Cards"
    }
    """
    And I save the response as "B"
    And I save the request endpoint for deleting
    And I send a "POST" request to "/lists" with json body
    """
    {
    "name": "ToDo",
    "idBoard": "(B.id)"
    }
    """
    And I save the response as "L"
    And I send a "POST" request to "/cards" with json body
    """
    {
    "name": "Card001 created by cucumber",
    "desc": "Card001 description by cucumber",
    "idList": "(L.id)"
    }
    """
    And I save the response as "C"

  @cleanData
  Scenario: DELETE Card
    When I send a "DELETE" request to "/cards/{C.id}"
    Then I validate the response has status code 200

  @cleanData
  Scenario: DELETE Card Labels
    When I send a "POST" request to "/labels" with json body
    """
    {
    "name": "Development",
    "color": "blue",
    "idBoard": "(B.id)"
    }
    """
    And I save the response as "LB"
    And I send a "POST" request to "/cards/{C.id}/idLabels" with json body
    """
    {
    "id": "(C.id)",
    "value": "(LB.id)"
    }
    """
    Then I send a "DELETE" request to "/cards/{C.id}/idLabels/{LB.id}"
    And I validate the response has status code 200
