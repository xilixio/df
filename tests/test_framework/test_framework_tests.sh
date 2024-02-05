#!/bin/bash
source ./test_framework.sh

declare -A t=(
    [description]="Adding 2 and 3"
    [command]="./sum.sh 2 3"
    [expected_output]="5"
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Adding with only one argument fails"
    [command]="./sum.sh 2"
    [expected_output]="Usage: ./sum.sh number1 number2"
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Multiline output"
    [command]="./multiline.sh"
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
    [command]="false"
    [expected_output]=""
    [expected_status]=1
); run_test t

test_summary
