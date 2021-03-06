@testing
@https://github.com/DonJayamanne/pyvscSmokeTesting/testing
Feature: Test Explorer - Re-run Failed Tests
    Background: Activted Extension
        Given a file named ".vscode/settings.json" is created with the following content
            """
            {
                "python.testing.unittestArgs": [
                    "-v",
                    "-s",
                    "./tests",
                    "-p",
                    "test_*.py"
                ],
                "python.testing.unittestEnabled": false,
                "python.testing.pytestArgs": ["."],
                "python.testing.pytestEnabled": false,
                "python.testing.nosetestArgs": ["."],
                "python.testing.nosetestsEnabled": false
            }
            """
        Given the Python extension has been activated

    Scenario Outline: We are able to re-run a failed tests (<package>)
        Given the package "<package>" is installed
        And the workspace setting "python.testing.<setting_to_enable>" is enabled
        When I select the command "Python: Discover Tests"
        And I wait for test discovery to complete
        Then the test explorer icon will be visible
        When I select the command "View: Show Test"
        And I expand all of the nodes in the test explorer
        Then there are <node_count> nodes in the test explorer
        And <node_count> nodes in the test explorer have a status of "Unknown"
        Given a file named "tests/test_running_delay" is created with the following content
            """
            0
            """
        And a file named "tests/data.json" is created with the following content
            """
            [1,-1,-1,4,5,6]
            """
        When I select the command "Python: Run All Tests"
        And I wait for tests to complete running
        Then the node "<test_one_file_label>" in the test explorer has a status of "Fail"
        And the node "TestFirstSuite" in the test explorer has a status of "Fail"
        And the node "test_three_first_suite" in the test explorer has a status of "Fail"
        And the node "test_two_first_suite" in the test explorer has a status of "Fail"
        And the node "<test_two_file_label>" in the test explorer has a status of "Fail"
        And the node "TestThirdSuite" in the test explorer has a status of "Fail"
        And the node "test_three_third_suite" in the test explorer has a status of "Fail"
        And the node "test_two_third_suite" in the test explorer has a status of "Fail"
        And 6 nodes in the test explorer have a status of "Success"
        And the run failed tests icon is visible in the toolbar
        Given a file named "tests/test_running_delay" is created with the following content
            """
            1
            """
        And a file named "tests/data.json" is created with the following content
            """
            [1,2,3,4,5,6]
            """
        When I run failed tests
        And I wait for tests to complete running
        And I expand all of the nodes in the test explorer
        Then <node_count> nodes in the test explorer have a status of "Success"

        Examples:
            | package  | setting_to_enable | node_count | test_one_file_label | test_two_file_label |
            | unittest | unittestEnabled   | 14         | test_one.py         | test_two.py         |
            | pytest   | pytestEnabled     | 15         | test_one.py         | test_two.py         |
            | nose     | nosetestsEnabled  | 14         | tests/test_one.py   | tests/test_two.py   |

    Scenario Outline: We are able to stop tests after re-running failed tests (<package>)
        Given the package "<package>" is installed
        And the workspace setting "python.testing.<setting_to_enable>" is enabled
        When I select the command "Python: Discover Tests"
        And I wait for test discovery to complete
        Then the test explorer icon will be visible
        When I select the command "View: Show Test"
        And I expand all of the nodes in the test explorer
        Then there are <node_count> nodes in the test explorer
        And <node_count> nodes in the test explorer have a status of "Unknown"
        Given a file named "tests/test_running_delay" is created with the following content
            """
            0
            """
        And a file named "tests/data.json" is created with the following content
            """
            [1,-1,-1,4,5,6]
            """
        When I select the command "Python: Run All Tests"
        And I wait for tests to complete running
        Then the node "<test_one_file_label>" in the test explorer has a status of "Fail"
        And the node "TestFirstSuite" in the test explorer has a status of "Fail"
        And the node "test_three_first_suite" in the test explorer has a status of "Fail"
        And the node "test_two_first_suite" in the test explorer has a status of "Fail"
        And the node "<test_two_file_label>" in the test explorer has a status of "Fail"
        And the node "TestThirdSuite" in the test explorer has a status of "Fail"
        And the node "test_three_third_suite" in the test explorer has a status of "Fail"
        And the node "test_two_third_suite" in the test explorer has a status of "Fail"
        And 6 nodes in the test explorer have a status of "Success"
        And the run failed tests icon is visible in the toolbar
        Given a file named "tests/test_running_delay" is created with the following content
            """
            100
            """
        And a file named "tests/data.json" is created with the following content
            """
            [1,2,3,4,5,6]
            """
        When I run failed tests
        Then the stop icon is visible in the toolbar
        And I expand all of the nodes in the test explorer
        Then the node "TestFirstSuite" in the test explorer has a status of "Progress"
        And the node "test_three_first_suite" in the test explorer has a status of "Progress"
        And the node "test_two_first_suite" in the test explorer has a status of "Progress"
        And the node "TestThirdSuite" in the test explorer has a status of "Progress"
        And the node "test_three_third_suite" in the test explorer has a status of "Progress"
        And the node "test_two_third_suite" in the test explorer has a status of "Progress"
        And <failed_node_count> nodes in the test explorer have a status of "Progress"
        When I stop running tests
        And I wait for tests to complete running
        Then the stop icon is not visible in the toolbar
        And the node "test_three_first_suite" in the test explorer has a status of "Unknown"
        And the node "test_two_first_suite" in the test explorer has a status of "Unknown"
        And the node "test_three_third_suite" in the test explorer has a status of "Unknown"
        And the node "test_two_third_suite" in the test explorer has a status of "Unknown"

        Examples:
            | package  | setting_to_enable | node_count | failed_node_count | test_one_file_label | test_two_file_label |
            | unittest | unittestEnabled   | 14         | 6                 | test_one.py         | test_two.py         |
            | pytest   | pytestEnabled     | 15         | 6                 | test_one.py         | test_two.py         |
            | nose     | nosetestsEnabled  | 14         | 6                 | tests/test_one.py   | tests/test_two.py   |
