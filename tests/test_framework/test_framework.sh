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

    echo -n "Test: $test_description ... "
    if [ "$actual_exit_status" -eq "$expected_exit_status" ]; then
        if [[ "$result" == "$expected_result" ]]; then
            echo "Passed"
            ((tests_passed++))
        else
            echo "Failed (Expected '$expected_result', got '$result')"
            ((tests_failed++))
        fi
    else
        echo "Failed - Expected exit status $expected_exit_status, got $actual_exit_status"
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
    echo "Tests run: $tests_run, Passed: $tests_passed, Failed: $tests_failed"
    if [ "$tests_failed" -ne 0 ]; then
        echo "Some tests failed."
        exit 1
    else
        echo "All tests passed."
    fi
}