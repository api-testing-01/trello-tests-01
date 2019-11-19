Feature: Boards

  Background:
    Given I use the "trello" service and the "owner" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board0001 created by cucumber"
    }
    """
    And I save the response as "P"
    And I save the request endpoint for deleting

  @cleanData
  Scenario: PUT Board
    When I send a "PUT" request to "/boards/{P.id}" with json body
    """
    {
    "name": "Board0001 updated by cucumber"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "Board0001 updated by cucumber"

  @cleanData
  Scenario: DELETE Board
    When I send a "DELETE" request to "/boards/{P.id}"
    Then I validate the response has status code 200

  @cleanData
  Scenario: Get Board plugins
    When I send a "GET" request to "/boards/{P.id}/plugins"
    And I save the response as "L"
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "[Butler]"
    And I validate the response contains "categories" equals '[[automation, board-utilities]]'
