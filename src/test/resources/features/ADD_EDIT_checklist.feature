Feature: Add and edit Checklists

  Background:
    Given I use the "trello" service and the "owner" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board for Checklist1"
    }
    """
    And I save the response as "B"
    And I save the request endpoint for deleting
    And I send a "POST" request to "/lists" with json body
    """
    {
    "name": "On hold list",
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
  Scenario: Add a checklist
    When I send a "POST" request to "/checklists" with json body
    """
    {
    "idCard": "(C.id)",
    "name": "Create Account",
    "pos": "16384"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "Create Account"
    And I validate the response contains "pos" equals "16384"

  @cleanData
  Scenario: Edit name and post checklist attributes (using id endpoint)
    Given I send a "POST" request to "/checklists" with json body
    """
    {
    "idCard": "(C.id)",
    "name": "Create Account",
    "pos": "16384"
    }
    """
    And I save the response as "CH"
    When I send a "PUT" request to "/checklists/{CH.id}" with json body
    """
    {
    "name": "Create Trello Account",
    "pos": "16390"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "Create Trello Account"
    And I validate the response contains "pos" equals "16390"

  @cleanData
  Scenario: Edit checklist name (using name endpoint)
    Given I send a "POST" request to "/checklists" with json body
    """
    {
    "idCard": "(C.id)",
    "name": "Create Account",
    "pos": "16384"
    }
    """
    And I save the response as "CH"
    When I send a "PUT" request to "/checklists/{CH.id}/name" with json body
    """
    {
    "value": "Updated checklist"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "Updated checklist"