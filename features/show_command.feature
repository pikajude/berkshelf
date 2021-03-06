Feature: Displaying information about a cookbook defined by a Berksfile
  As a user
  I want to be able to view the metadata information of a cached cookbook
  So that I can troubleshoot bugs or satisfy my own curiosity

  Scenario: With no options
    Given the cookbook store has the cookbooks:
      | fake | 1.0.0 |
    And I write to "Berksfile" with:
      """
      source "http://localhost:26210"

      cookbook 'fake', '1.0.0'
      """
    And I write to "Berksfile.lock" with:
      """
      {
        "dependencies": {
          "fake": {
            "locked_version": "1.0.0"
          }
        }
      }
      """
    When I successfully run `berks show fake`
    Then the output should contain:
      """
              Name: fake
           Version: 1.0.0
       Description: A fabulous new cookbook
            Author: YOUR_COMPANY_NAME
             Email: YOUR_EMAIL
           License: none
      """

  Scenario: When JSON is requested
    Given the cookbook store has the cookbooks:
      | fake | 1.0.0 |
    And I write to "Berksfile" with:
      """
      source "http://localhost:26210"

      cookbook 'fake', '1.0.0'
      """
    And I write to "Berksfile.lock" with:
      """
      {
        "dependencies": {
          "fake": {
            "locked_version": "1.0.0"
          }
        }
      }
      """
    When I successfully run `berks show fake --format json`
    Then the output should contain JSON:
      """
      {
        "cookbooks": [
          {
            "name": "fake",
            "version": "1.0.0",
            "description": "A fabulous new cookbook",
            "author": "YOUR_COMPANY_NAME",
            "email": "YOUR_EMAIL",
            "license": "none"
          }
        ],
        "errors": [

        ],
        "messages": [
        ]
      }
      """

  Scenario: When the cookbook is not in the Berksfile
    Given I write to "Berksfile" with:
      """
      source "http://localhost:26210"
      """
    When I run `berks show fake`
    Then the output should contain:
      """
      Could not find cookbook(s) 'fake' in any of the configured dependencies. Is it in your Berksfile?
      """
    And the exit status should be "CookbookNotFound"

  Scenario: When there is no lockfile present
    And I write to "Berksfile" with:
      """
      source "http://localhost:26210"

      cookbook 'fake', '1.0.0'
      """
    When I run `berks show fake`
    Then the output should contain:
      """
      Could not find cookbook 'fake (>= 0.0.0)'. Try running `berks install` to download and install the missing dependencies.
      """
    And the exit status should be "LockfileNotFound"

  Scenario: When the cookbook is not installed
    And I write to "Berksfile" with:
      """
      source "http://localhost:26210"

      cookbook 'fake', '1.0.0'
      """
    And I write to "Berksfile.lock" with:
      """
      {
        "dependencies": {
          "fake": {
            "locked_version": "1.0.0"
          }
        }
      }
      """
    When I run `berks show fake`
    Then the output should contain:
      """
      Could not find cookbook 'fake (= 1.0.0)'. Try running `berks install` to download and install the missing dependencies.
      """
    And the exit status should be "CookbookNotFound"
