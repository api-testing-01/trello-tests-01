Feature: Boundary and negative Checklists scenarios

  Background:
    Given I use the "trello" service and the "owner" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board for Checklist5"
    }
    """
    And I save the response as "B"
    And I save the request endpoint for deleting
    And I send a "POST" request to "/lists" with json body
    """
    {
    "name": "Negative list",
    "idBoard": "(B.id)"
    }
    """
    And I save the response as "L"
    And I send a "POST" request to "/cards" with json body
    """
    {
    "name": "Card Trello",
    "idList": "(L.id)"
    }
    """
    And I save the response as "C"

  @cleanData
  Scenario: Verify a checklist name can be saved with a min length of 1 character for the name
    When I send a "POST" request to "/checklists" with json body
    """
    {
    "idCard": "(C.id)",
    "name": "X",
    "pos": "1"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "X"
    And I validate the response contains "pos" equals "1"

  @cleanData
  Scenario: Verify a checklist can be saved with a max length of 16384 characters for the name
    When I send a "POST" request to "/checklists" with json file "json/checklistLongName.json"
    Then I validate the response has status code 200
    And I validate the response contains "pos" equals "16384"

  @cleanData
  Scenario: Verify a checklist is saved with default "Checklist" name when this attribute is not defined
    When I send a "POST" request to "/checklists" with json body
    """
    {
    "idCard": "(C.id)",
    "pos": "1000"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "Checklist"
    And I validate the response contains "pos" equals "1000"

  @cleanData
  Scenario: Verify a checklist cannot be saved when the name exceed the max length of 16384 characters
    When I send a "POST" request to "/checklists" with json file "json/checklistExceedLengthName.json"
    Then I validate the response has status code 400
