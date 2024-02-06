#!/bin/bash

current_os=$(uname -s)

declare -A t=(
    [description]="Package is not installed on current OS"
    [before_test]=""
    [test]="bin/df check pk1"
    [after_test]=""
    [expected_output]="Package 'pk1' is not installed on $current_os."
    [expected_status]=1
); run_test t

