#!/bin/bash
dir=$(dirname "$(readlink -f "$0")")
source "$dir/test_framework.sh"

declare -A t=(
    [description]="Adding 2 and 3"
    [command]="$dir/sum.sh 2 3"
    [expected_output]="5"
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Adding with only one argument fails"
    [command]="$dir/sum.sh 2"
    [expected_output]="Usage: $dir/sum.sh number1 number2"
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Multiline output"
    [command]="$dir/multiline.sh"
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
