Feature: Lists

  Background:
    Given I use the "trello" service and the "user2" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board1 for listGC"
    }
    """
    And I save the response as "B1"
    And I save the request endpoint for deleting
    And I send a "POST" request to "/lists" with json body
    """
    {
    "name": "List1 for Board1GC",
    "idBoard":"(B1.id)"
    }
    """
    And I save the response as "L1"
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board2 for listGC"
    }
    """
    And I save the response as "B2"
    And I save the request endpoint for deleting
    And I send a "POST" request to "/lists" with json body
    """
    {
    "name": "List2 for Board2GC",
    "idBoard":"(B2.id)"
    }
    """
    And I save the response as "L2"

  @cleanData
  Scenario: Get List
    When I send a "GET" request to "/lists/{L1.id}"
    Then I validate the response has status code 200
    And I validate the response contains "idBoard" equals "{B1.id}"

  @cleanData
  Scenario: Get List sending fields in body
    When I send a "GET" request to "/lists/{L2.id}" with json body
    """
    {
    "fields": "name, closed"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "idBoard" equals "{B2.id}"
    And I validate the response contains "closed" equals "false"

  @cleanData
  Scenario Outline: Get only one field of List
    When I send a "GET" request to "/lists/{L2.id}/<field>"
    Then I validate the response has status code 200
    And I validate the response contains "_value" equals "<value>"

    Examples:
      | field   | value              |
      | name    | List2 for Board2GC |
      | closed  | false              |
      | idBoard | {B2.id}            |

  @cleanData
  Scenario Outline: Close List
    When I send a "PUT" request to "/lists/{L1.id}/closed" with json body
    """
    {
    "value": "<public>"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "closed" equals "<public>"

    Examples:
      | public |
      | true   |
      | false  |