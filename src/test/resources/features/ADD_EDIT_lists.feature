Feature: Lists

  Background:
    Given I use the "trello" service and the "owner" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board1 for list 1"
    }
    """
    And I save the response as "B1"
    And I save the request endpoint for deleting
    And I send a "POST" request to "/lists" with json body
    """
    {
    "name": "List 1 for Board 1",
    "idBoard":"(B1.id)"
    }
    """
    And I save the response as "L1"
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board2 for list 2"
    }
    """
    And I save the response as "B2"
    And I save the request endpoint for deleting
    And I send a "POST" request to "/lists" with json body
    """
    {
    "name": "List 2 for Board 2",
    "idBoard":"(B2.id)"
    }
    """
    And I save the response as "L2"

  @cleanData
  Scenario: Add List
    When I send a "POST" request to "/lists" with json body
    """
    {
    "name": "List 2 for Board 1",
    "idBoard":"(B1.id)"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "List 2 for Board 1"

  @cleanData
  Scenario: Update name and Status in List using params
    When I send a "PUT" request to "/lists/{L1.id}" with json body
    """
    {
    "name": "List1 name updated for Board 1",
    "closed": true
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "List1 name updated for Board 1"
    And I validate the response contains "closed" equals "true"

  @cleanData
  Scenario: Move List from one board to another
    When I send a "PUT" request to "/lists/{L1.id}" with json body
    """
    {
    "idBoard": "(B2.id)"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "idBoard" equals "{B2.id}"

  @cleanData
  Scenario: Update List name
    When I send a "PUT" request to "/lists/{L2.id}/name" with json body
    """
    {
    "value": "This is a new name for List2"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "This is a new name for List2"

  @cleanData
  Scenario: Update List position
    When I send a "POST" request to "/lists" with json body
    """
    {
    "name": "List 3 for Board 1 ",
    "idBoard":"(B1.id)"
    }
    """
    And I save the response as "L3"
    And I send a "POST" request to "/lists" with json body
    """
    {
    "name": "List 4 for Board 1 ",
    "idBoard":"(B1.id)"
    }
    """
    And I save the response as "L4"
    And I send a "PUT" request to "/lists/{L3.id}/pos" with json body
    """
    {
    "value": "top"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "pos" equals "1024"

  @cleanData
  Scenario: Move cards from one list and board to another
    When I send a "POST" request to "/cards" with json body
    """
    {
    "name": "Card 1 for List 1",
    "idList": "(L1.id)"
    }
    """
    And I save the response as "C1"
    And I send a "POST" request to "/cards" with json body
    """
    {
    "name": "Card 2 for List 1",
    "idList": "(L1.id)"
    }
    """
    And I save the response as "C2"
    And I send a "POST" request to "/cards" with json body
    """
    {
    "name": "Card 1 for List 2",
    "idList": "(L2.id)"
    }
    """
    And I save the response as "C3"
    And I send a "POST" request to "/lists/{L1.id}/moveAllCards" with json body
    """
    {
    "idBoard": "(B2.id)",
    "idList": "(L2.id)"
    }
    """
    Then I validate the response has status code 200
    And I send a "GET" request to "/cards/{C1.id}/list"
    And I validate the response contains "id" equals "{L2.id}"
    And I send a "GET" request to "/cards/{C2.id}/list"
    And I validate the response contains "id" equals "{L2.id}"
    And I send a "GET" request to "/cards/{C3.id}/list"
    And I validate the response contains "id" equals "{L2.id}"

  @cleanData
  Scenario Outline: Subscribe and unsubscribe list
    When I send a "PUT" request to "/lists/{L1.id}/subscribed" with json body
    """
    {
    "value": "<value>"
    }
    """
    Then I validate the response has status code 200

    Examples:
      | value |
      | true  |
      | false |
