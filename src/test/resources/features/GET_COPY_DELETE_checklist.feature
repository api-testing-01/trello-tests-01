Feature: Get, copy and delete Checklists

  Background:
    Given I use the "trello" service and the "owner" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board for Checklist2"
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
    "name": "Card Test",
    "idList": "(L.id)"
    }
    """
    And I save the response as "C"
    And I send a "POST" request to "/cards" with json body
    """
    {
    "name": "Card2",
    "idList": "(L.id)"
    }
    """
    And I save the response as "CC"
    And I send a "POST" request to "/checklists" with json body
    """
    {
    "idCard": "(CC.id)",
    "name": "Checklist to copy",
    "pos": "16380"
    }
    """
    And I save the response as "CHC"

  @cleanData
  Scenario: Get checklist given its id returns the checklist name
    When I send a "GET" request to "/checklists/{CHC.id}"
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "Checklist to copy"

  @cleanData
  Scenario: Get card name of checklist using nested resources
    When I send a GET request to "/checklists/{CHC.id}" with urlParam
      | fields      | name |
      | cards       | open |
      | card_fields | name |
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "Checklist to copy"
    And I validate the response contains "cards.name" equals "[Card2]"

  @cleanData
  Scenario Outline: Get board, cards details of checklist using nested resources
    When I send a GET request to "<endpoint>" with urlParam
      | fields | name,closed |
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "<resultName>"
    And I validate the response contains "closed" equals "<resultStatus>"

    Examples:
      | endpoint                  | resultName           | resultStatus |
      | checklists/{CHC.id}/board | Board for Checklist2 | false        |
      | checklists/{CHC.id}/cards | [Card2]              | [false]      |

  @cleanData
  Scenario: Copy checklist from Card2 to Card Test
    When I send a "POST" request to "/checklists" with json body
    """
    {
    "idCard": "(C.id)",
    "idChecklistSource": "(CHC.id)",
    "pos": "16382"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "Checklist to copy"
    And I validate the response contains "pos" equals "16382"

  @cleanData
  Scenario: Delete checklist from card
    When I send a "DELETE" request to "/checklists/{CHC.id}"
    Then I validate the response has status code 200