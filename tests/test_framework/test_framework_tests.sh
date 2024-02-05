#!/bin/bash
source ./test_framework.sh

run_test "Adding 2 and 3" "./sum.sh 2 3" "5" 0 # Successful 
run_test "Adding with only one argument" "./sum.sh 2" "Usage: ./sum.sh number1 number2" 1 # Failure 
multi_line_var=$(cat <<EOF
This
is
some
multiline
output
EOF
)
run_test "Multiline output" "./multiline.sh" "$multi_line_var" 0 # Success
run_test "Simulate failure" "false" "" 1 # Failure (exit status)

test_summary
