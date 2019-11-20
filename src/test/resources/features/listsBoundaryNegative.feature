Feature: Boundary and negative scenarios for Lists

  Background:
    Given I use the "trello" service and the "owner" account
    And I send a "POST" request to "/boards" with json body
    """
    {
    "name": "Board1 for listNT"
    }
    """
    And I save the response as "B1"
    And I save the request endpoint for deleting
    And I send a "POST" request to "/lists" with json body
    """
    {
    "name": "List1 for BoardNT",
    "idBoard":"(B1.id)"
    }
    """
    And I save the response as "L1"

  @cleanData
  Scenario: Close a list already closed
    When I send a "PUT" request to "/lists/{L1.id}" with json body
    """
    {
    "closed": "true"
    }
    """
    And I validate the response contains "closed" equals "true"
    Then I send a "PUT" request to "/lists/{L1.id}" with json body
    """
    {
    "closed": "true"
    }
    """
    And I validate the response has status code 200
    And I validate the response contains "closed" equals "true"

  @cleanData
  Scenario: Update list name with special characters
    When I send a "PUT" request to "/lists/{L1.id}/name" with json body
    """
    {
    "value": "!~@#!%$&*_+&"
    }
    """
    Then I validate the response has status code 200
    And I validate the response contains "name" equals "!~@#!%$&*_+&"

  @cleanData
  Scenario: Add negative numbers in pos field of list
    When I send a "PUT" request to "/lists/{L1.id}" with json body
    """
    {
    "pos": "-1000"
    }
    """
    Then I validate the response has status code 400
    And I validate the response contains "message" equals "Invalid position."

  @cleanData
  Scenario: Add a softlimit List outside the accepted range
    When I send a "PUT" request to "/lists/{L1.id}/softLimit" with json body
    """
    {
    "value": "10000"
    }
    """
    Then I validate the response has status code 400
    And I validate the response contains "message" equals "invalid value for value"
