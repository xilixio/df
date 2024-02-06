#!/bin/bash

os=$(uname -s)

declare -A t=(
    [description]="Package is not defined in package.yaml"
    [before_test]=""
    [test]="bin/df check pkX"
    [after_test]=""
    [expected_output]="Package 'pkX' is not defined in 'packages.yaml'."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Package doesn't define an OS"
    [before_test]=""
    [test]="bin/df check pk_no_os"
    [after_test]=""
    [expected_output]="Package's 'pk_no_os' OS '$os' is not defined in 'packages.yaml'."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Package is missing 'check' entry"
    [before_test]=""
    [test]="bin/df check pk_no_check"
    [after_test]=""
    [expected_output]="Missing 'check' entry on 'packages.pk_no_check.$os' in 'packages.yaml'."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Package is not installed on current OS"
    [before_test]=""
    [test]="bin/df check pk1"
    [after_test]=""
    [expected_output]="Package 'pk1' is not installed on $os."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Package is installed on current OS"
    [before_test]="touch /tmp/pk1.tmp"
    [test]="bin/df check pk1"
    [after_test]="rm /tmp/pk1.tmp"
    [expected_output]="Package 'pk1' is installed on $os."
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Package is not installed on current OS, silent"
    [before_test]=""
    [test]="bin/df check pk1 -s"
    [after_test]=""
    [expected_output]=""
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Package is installed on current OS, silent"
    [before_test]="touch /tmp/pk1.tmp"
    [test]="bin/df check pk1 -s"
    [after_test]="rm /tmp/pk1.tmp"
    [expected_output]=""
    [expected_status]=0
); run_test t