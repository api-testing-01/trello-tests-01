Feature: Get and delete checkItems in checklist

  Background:
    Given I use the "trello" service and the "owner" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board for Checklist4"
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
    And I send a "POST" request to "/checklists/{CH.id}/checkItems" with json body
    """
    {
    "name": "Add scenarios",
    "pos": "16350",
    "checked": "true"
    }
    """
    And I send a "POST" request to "/checklists/{CH.id}/checkItems" with json body
    """
    {
    "name": "Refactor scenarios",
    "pos": "16355",
    "checked": "false"
    }
    """
    And I save the response as "CI2"

  @cleanData
  Scenario: Get checkItems details of a checklist
    When I send a "GET" request to "/checklists/{CH.id}/checkItems"
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "[Add scenarios, Refactor scenarios]"
    And I validate the response contains "pos" equals "[16350, 16355]"
    And I validate the response contains "state" equals "[complete, incomplete]"

  @cleanData
  Scenario: Get checkItem details by id
    When I send a GET request to "/checklists/{CH.id}/checkItems/{CI2.id}" with urlParam
      | fields      | all |
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "Refactor scenarios"
    And I validate the response contains "pos" equals "16355"
    And I validate the response contains "state" equals "incomplete"

  @cleanData
  Scenario: Delete a checkItem from checklist
    When I send a "DELETE" request to "/checklists/{CH.id}/checkItems/{CI2.id}"
    Then I validate the response has status code 200
    And I send a "GET" request to "/checklists/{CH.id}/checkItems/{CI2.id}"
    And I validate the response has status code 404