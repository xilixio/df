#!/usr/bin/env bash
# Requires Bash 4.0+ (associative arrays)

declare -A t=(
    [description]="Adding 2 and 3"
    [test]="tests/_sum.sh 2 3"
    [expected_output]="5"
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Adding with only one argument fails"
    [test]="tests/_sum.sh 2"
    [expected_output]="Usage: tests/_sum.sh number1 number2"
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Multiline output"
    [test]="tests/_multiline.sh"
    [expected_output]=$(cat <<EOF
This
is
some
multiline
output
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Simulate failure"
    [test]="false"
    [expected_output]=""
    [expected_status]=1
); run_test t

