Feature: Lists

  Background:
    Given I use the "trello" service and the "owner" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board1 for list 1"
    }
    """
    And I save the response as "B"
    And I save the request endpoint for deleting
    And I send a "POST" request to "/lists" with json body
    """
    {
    "name": "List 1 for Board 1",
    "idBoard":"(B.id)"
    }
    """
    And I save the response as "L"

  @cleanData
  Scenario: Add List
    When I send a "POST" request to "/lists" with json body
    """
    {
    "name": "List 2 for Board 1",
    "idBoard":"(B.id)"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "List 2 for Board 1"

  @cleanData
  Scenario: Update name and Status in List
    When I send a "PUT" request to "/lists/{L.id}" with json body
    """
    {
    "name": "List name updated for Board 1",
    "closed": true
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "List name updated for Board 1"
    And I validate the response contains "closed" equals "true"

  @cleanData
  Scenario: Move List from one board to another
    When I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board2 for list 1"
    }
    """
    And I save the response as "B2"
    And I save the request endpoint for deleting
    And I send a "PUT" request to "/lists/{L.id}" with json body
    """
    {
    "idBoard": "(B2.id)"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "idBoard" equals "{B2.id}"
