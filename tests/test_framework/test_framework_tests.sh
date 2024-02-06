#!/bin/bash
dir="$PWD/tests/test_framework"

declare -A t=(
    [description]="Adding 2 and 3"
    [test]="$dir/sum.sh 2 3"
    [expected_output]="5"
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Adding with only one argument fails"
    [test]="$dir/sum.sh 2"
    [expected_output]="Usage: $dir/sum.sh number1 number2"
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Multiline output"
    [test]="$dir/multiline.sh"
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

