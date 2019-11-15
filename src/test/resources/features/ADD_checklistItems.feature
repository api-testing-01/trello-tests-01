Feature: Add checkItems in checklist

  Background:
    Given I use the "trello" service and the "user2" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board for Checklist3"
    }
    """
    And I save the response as "B"
    And I save the request endpoint for deleting
    And I add "user3" as admin member to board with id "{B.id}"
    And I send a "POST" request to "/lists" with json body
    """
    {
    "name": "CheckItem List3",
    "idBoard": "(B.id)"
    }
    """
    And I save the response as "L"
    And I send a "POST" request to "/cards" with json body
    """
    {
    "name": "Card3",
    "idList": "(L.id)"
    }
    """
    And I save the response as "C"
    And I send a "POST" request to "/checklists" with json body
    """
    {
    "idCard": "(C.id)",
    "name": "Trello CheckItem2",
    "pos": "16380"
    }
    """
    And I save the response as "CH"

  @cleanData
  Scenario Outline: Add checkItem
    When I use the "trello" service and the "user3" account
    And I send a "POST" request to "/checklists/{CH.id}/checkItems" with json body
    """
    {
    "name": "<checkItem>",
    "pos": "16352",
    "checked": "<checked>"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "<checkItem>"
    And I validate the response contains "pos" equals "16352"
    And I validate the response contains "state" equals "<state>"

    Examples:
      | checkItem          | checked | state      |
      | Identify scenarios | true    | complete   |
      | Write scenarios    | false   | incomplete |
