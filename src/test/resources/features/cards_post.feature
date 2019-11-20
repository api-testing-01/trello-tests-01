Feature: Cards

  Background:
    Given I use the "trello" service and the "user4" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board for Cards"
    }
    """
    And I save the response as "B"
    And I save the request endpoint for deleting
    And I send a "POST" request to "/lists" with json body
    """
    {
    "name": "ToDo",
    "idBoard": "(B.id)"
    }
    """
    And I save the response as "L"
    And I send a "POST" request to "/cards" with json body
    """
    {
    "name": "Card001 created by cucumber",
    "desc": "Card001 description by cucumber",
    "idList": "(L.id)"
    }
    """
    And I save the response as "C"

  @cleanData
  Scenario: POST Card comments
    When I send a "POST" request to "/cards/{C.id}/actions/comments" with json body
    """
    {
    "id": "(C.id)",
    "text": "Please add more details to the card in order to estimate accurately"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "data.text" equals "Please add more details to the card in order to estimate accurately"

  @cleanData
  Scenario: POST Card Labels
    When I send a "POST" request to "/labels" with json body
    """
    {
    "name": "Unit Test",
    "color": "blue",
    "idBoard": "(B.id)"
    }
    """
    And I save the response as "LB"
    Then I send a "POST" request to "/cards/{C.id}/idLabels" with json body
    """
    {
    "id": "(C.id)",
    "value": "(LB.id)"
    }
    """
    And I validate the response has status code 200

  @cleanData
  Scenario: POST Card Comments
    When I send a "POST" request to "/cards/{C.id}/actions/comments" with json body
    """
    {
    "text": "New Comment"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "data.text" equals "New Comment"

  @cleanData
  Scenario: POST Card Stickers Negative Testing
    When I send a "POST" request to "/cards/{C.id}/stickers" with json body
    """
    {
      "id": "(C.id)",
      "image": "taco-cool",
      "top": "60",
      "left": "60",
      "zIndex": "1"
    }
    """
    Then I validate the response has status code 401
    And I validate the response contains "error" equals "PRODUCT_FEATURE_NOT_ENABLED"
    And I validate the response contains "message" equals "premium stickers not enabled"

  @cleanData
  Scenario: POST Card Special Characters Name
    When I send a "POST" request to "/cards/" with json body
    """
    {
    "name": "!##$$%,%%%^&",
    "idList": "(L.id)"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "!##$$%,%%%^&"

  @cleanData
  Scenario: POST Card empty Name Boundary Testing
    When I send a "POST" request to "/cards/" with json body
    """
    {
    "name": "",
    "idList": "(L.id)"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals ""