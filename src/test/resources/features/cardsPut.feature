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
  Scenario: PUT Card
    When I send a "PUT" request to "/cards/{C.id}" with json body
    """
    {
    "name": "Card001 updated by cucumber",
    "desc": "Card001 updated description by cucumber",
    "idList": "(L.id)",
    "closed": true,
    "due": "2019-12-14T20:58:05.914Z",
    "isTemplate": true
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "Card001 updated by cucumber"
    And I validate the response contains "desc" equals "Card001 updated description by cucumber"
    And I validate the response contains "closed" equals "true"
    And I validate the response contains "due" equals "2019-12-14T20:58:05.914Z"
    And I validate the response contains "isTemplate" equals "true"
