#!/bin/bash

declare -A t=(
    [description]="Package has no cyclic dependencies"
    [test]="bin/df deps-cd pk1"
    [expected_output]=""
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Package has a cyclic dependency"
    [test]="bin/df deps-cd pkCD1"
    [expected_output]="A cyclic dependency involving 'pkCD1' was found in the path '<root>->pkCD1->pkCD2->pkCD1'."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="No arguments checks all packages and detects a cyclic dependency"
    [test]="bin/df deps-cd"
    [expected_output]="A cyclic dependency involving 'pkCD1' was found in the path '<root>->pkCD1->pkCD2->pkCD1'."
    [expected_status]=1
); run_test t