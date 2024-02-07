#!/bin/bash

declare -A t=(
    [description]="Get the dependencies of a package"
    [test]="bin/df deps-list pk1"
    [expected_output]=$(cat <<EOF
pk2
pk3
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Throw if package doesn't exist"
    [before_test]=""
    [test]="bin/df deps-list pk1010101"
    [after_test]=""
    [expected_output]="Package 'pk1010101' is not defined in 'packages.yaml'."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Get empty deps"
    [before_test]=""
    [test]="bin/df deps-list pk3"
    [after_test]=""
    [expected_output]=""
    [expected_status]=0
); run_test t
