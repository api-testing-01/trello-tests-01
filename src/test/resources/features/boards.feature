Feature: Boards

  Background:
    Given I use the "trello" service and the "owner" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board0001 created by cucumber",
    "prefs_permissionLevel": "public"
    }
    """
    And I save the response as "P"
    And I save the request endpoint for deleting
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board0002 created by cucumber",
    "prefs_permissionLevel": "private"
    }
    """
    And I save the response as "P1"
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

  @cleanData
  Scenario: Get a public board
    Then I send a "GET" request to "/boards/{P.id}"
    And I validate the response contains "prefs.permissionLevel" equals "public"
    And I validate the response contains "name" equals "Board0001 created by cucumber"

  @cleanData
  Scenario: Get a private board
    Then I send a "GET" request to "/boards/{P1.id}"
    And I validate the response contains "prefs.permissionLevel" equals "private"
    And I validate the response contains "name" equals "Board0002 created by cucumber"