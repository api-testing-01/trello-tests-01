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

  @cleanData
  Scenario: POST Card default
    When I send a "POST" request to "/cards" with json body
    """
    {
    "name": "Card001 created by cucumber",
    "desc": "Card001 description by cucumber",
    "idList": "(L.id)"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "Card001 created by cucumber"
    And I validate the response contains "desc" equals "Card001 description by cucumber"

