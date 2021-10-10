Feature: User List
    So that I can manage access to the app
    As a user
    I want to list and manage users

    Scenario: 2.1 Clicking "Create User" brings up the user creation form
        Given Following users exists:
            | email | name | password |
            | user@example.com | Test User | password |
        And I sign in with email "user@example.com" and password "password"
        And I tap the "addUser" button
        Then I expect the widget "createUserForm" to be present within 1 second

    Scenario: 2.2 A newly-added user with a valid password is able to sign in
        Given Following users exists:
            | email | name | password |
            | user@example.com | Test User | password |
        And I sign in with email "user@example.com" and password "password"
        And I tap the "addUser" button
        And I fill the "fullName" field with "Test User 2"
        And I fill the "password" field with "password2"
        And I fill the "emailAddress" field with "user2@address.com"
        And I tap the "createUser" button
        And I tap the button that contains the text "Finish"
        And I sign out
        And I fill the "email" field with "user2@address.com"
        And I fill the "password" field with "password2"
        When I tap the button that contains the text "Login"
        Then I expect the widget "userListScreen" to be present within 1 second
        And I should see the following users:
            | Name      |
            | Test User |
            | Test User 2 |

