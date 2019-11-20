Feature: Cards

  Background:
    Given I use the "trello" service and the "user4" account
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
    And I send a "POST" request to "/cards/{C.id}/actions/comments" with json body
    """
    {
    "text": "New Comment"
    }
    """
    And I save the response as "CO"

  @cleanData
  Scenario: Get Card Board
    When I send a "GET" request to "/cards/{C.id}/board"
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "{B.name}"
    And I validate the response contains "desc" equals ""

  @cleanData
  Scenario: Get Card
    When I send a "GET" request to "/cards/{C.id}"
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "Card001 created by cucumber"
    And I validate the response contains "desc" equals "Card001 description by cucumber"
    And I validate the response contains "closed" equals "false"
    And I validate the response contains "dueComplete" equals "false"

  @cleanData
  Scenario: Get Card field
    When I send a "GET" request to "/cards/{C.id}/desc"
    Then I validate the response has status code 200
    And I validate the response contains "_value" equals "Card001 description by cucumber"

  @cleanData
  Scenario: Get Card actions
    When I send a "GET" request to "/cards/{C.id}/actions"
    Then I validate the response has status code 200
    And I validate the response contains "type" equals "[commentCard]"
    And I validate the response contains "data.text" equals "[New Comment]"

  @cleanData
  Scenario: Get Card Negative not existing card id
    When I send a "GET" request to "/cards/000"
    Then I validate the response has status code 400
