Feature: Add checkItems in checklist

  Background:
    Given I use the "trello" service and the "owner" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board for Checklist3"
    }
    """
    And I save the response as "B"
    And I save the request endpoint for deleting
    And I send a "POST" request to "/lists" with json body
    """
    {
    "name": "Working List",
    "idBoard": "(B.id)"
    }
    """
    And I save the response as "L"
    And I send a "POST" request to "/cards" with json body
    """
    {
    "name": "Card1",
    "idList": "(L.id)"
    }
    """
    And I save the response as "C"
    And I send a "POST" request to "/checklists" with json body
    """
    {
    "idCard": "(C.id)",
    "name": "Trello Checklist",
    "pos": "16380"
    }
    """
    And I save the response as "CH"

  @cleanData
  Scenario Outline: Add checkItem
    When I send a "POST" request to "/checklists/{CH.id}/checkItems" with json body
    """
    {
    "name": "<checkItem>",
    "pos": "16350",
    "checked": "<checked>"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "<checkItem>"
    And I validate the response contains "pos" equals "16350"
    And I validate the response contains "state" equals "<state>"

    Examples:
      | checkItem          | checked | state      |
      | Identify scenarios | true    | complete   |
      | Add scenarios      | false   | incomplete |
