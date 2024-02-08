#!/bin/bash

declare -A t=(
    [description]="Throw if package doesn't exist."
    [test]="bin/df install-package pkNoNo"
    [expected_output]="Failed to install package 'pkNoNo'. Package is not defined in packages.yaml."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if package has cyclic dependencies"
    [test]="bin/df install-package pkCD1"
    [expected_output]="A cyclic dependency involving 'pkCD1' was found in the path '<root>->pkCD1->pkCD2->pkCD1'."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if the package installation fails"
    [test]="bin/df install-package pkFailed"
    [expected_output]="Failed installing package 'pkFailed'. Error: Some error."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Install package and its dependencies"
    [test]="bin/df install-package pk1 -y && 
            bin/df check pk1 -s && \
            bin/df check pk2 -s && \
            bin/df check pk3 -s"
    [after_test]="rm /tmp/pk1.tmp || /tmp/pk2.tmp || /tmp/pk3.tmp || true"
    [expected_output]="Successfully installed package 'pk1' and its dependencies."
    [expected_status]=0
); run_test t