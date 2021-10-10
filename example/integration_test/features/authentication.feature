Feature: Authentication
    So that I can access the app
    As a user
    I want to authenticate and logout

    Scenario: 1.1 User enters valid credentials that aren't tied to a user account
        Given following users exists:
            | Email | Name | Password |
            | user@example.com | Test User | password |
        Given I fill the "email" field with "a_valid_email@notgettingin.com"
        And I fill the "password" field with "any_password"
        And I tap the button that contains the text "Login"
        Then I expect the text "Email and/or password is invalid. Please try again or contact support." to be present within the "loginErrorMessage"

    Scenario: 1.2 A manager signs in
        Given following users exists:
            | Email | Name | Password |
            | user@example.com | Test User | password |
        Given I sign in with email "user@example.com" and password "password"
        Then I expect the widget "userListScreen" to be present within 1 second

    Scenario: 1.3 Any user can log out
        Given following users exists:
            | Email | Name | Password |
            | user@example.com | Test User | password |
        Given I sign in with email "user@example.com" and password "password"
        When I tap the button that contains the text "Log Out"
        Then I expect the widget "AuthScreen" to be present within 1 second
