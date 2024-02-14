#!/bin/bash

declare -A t=(
    [description]="Dummy"
    [before_test]=""
    [test]=""
    [after_test]=""
    [expected_output]=""
    [expected_status]=1
); run_test t
