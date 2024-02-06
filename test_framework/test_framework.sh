#!/bin/bash

# Initialize variables
tests_run=0
tests_passed=0
tests_failed=0

# Function to run a test
run_test_inline() {
    ((tests_run++))
    test_description="$1"
    command_to_test="$2"
    expected_result="$3"
    expected_exit_status="${4:-0}" # Default exit status is 0 if not specified

    # Create a temporary file for the command output
    temp_file=$(mktemp)

    # Execute the command, redirecting output to the temp file, capturing both stdout and stderr
    eval "$command_to_test" > "$temp_file" 2>&1
    actual_exit_status=$?

    # Read the output from the temp file
    result=$(<"$temp_file") # Using redirection is slightly more efficient than cat

    # Cleanup: remove the temporary file
    rm -f "$temp_file"

    echo -en "\033[0;34m- Test:\033[0m $test_description ... "
    if [ "$actual_exit_status" -eq "$expected_exit_status" ]; then
        if [[ "$result" == "$expected_result" ]]; then
            echo -e "\033[0;32mPassed\033[0m"
            ((tests_passed++))
        else
            echo -e "\033[0;31mFailed\033[0m"
            echo -e "\033[0;34m- Got:\033[0m"
            echo -e "\033[0;31m$result\033[0m\n"
            echo -e "\033[0;34m- Expected:\033[0m"
            echo -e "\033[0;32m$expected_result\033[0m\n"
            echo -e "\033[0;34m- Diff:\033[0m"
            diff <(echo "$expected_result") <(echo "$result") --color=always
            echo ""

            ((tests_failed++))
        fi
    else
        echo -e "\033[0;31mFailed\033[0m - Expected exit status \033[0;32m$expected_exit_status\033[0m, got \033[0;31m$actual_exit_status\033[0m"
        echo -e "\033[0;34m- Output:\033[0m"
        echo "$result"
        ((tests_failed++))
    fi
}

run_test() {
    local -n params=$1 # Use nameref for indirect reference to the associative array
    run_test_inline \
        "${params[description]}" \
        "${params[command]}" \
        "${params[expected_output]}" \
        "${params[expected_status]}"
}

# Function to display test summary
test_summary() {
    echo -e "\nTests run: $tests_run, Passed: $tests_passed, Failed: $tests_failed"
    if [ "$tests_failed" -ne 0 ]; then
        echo -e "\033[0;31mSome tests failed\033[0m"
        exit 1
    else
        echo -e "\033[0;32mAll tests passed\033[0m"
    fi
}