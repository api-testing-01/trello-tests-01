Feature: Get Members

  Background:
    Given I use the "trello" service and the "user1" account

  Scenario: Get member given its id returns the full name
    And I send a "GET" request to "/members/marcomendieta"
    Then I validate the response has status code 200
    And I validate the response contains "fullName" equals "Marco Mendieta"