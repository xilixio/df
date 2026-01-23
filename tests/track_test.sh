#!/usr/bin/env bash
# Requires Bash 4.0+ (associative arrays)

declare -A t=(
    [description]="Throw if no path is defined"
    [before_test]=""
    [test]="dfm track pk1"
    [after_test]=""
    [expected_output]="Usage: track <package> <paths...>"
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if package is not defined"
    [before_test]=""
    [test]="dfm track pkx file1"
    [after_test]=""
    [expected_output]="Package 'pkx' is not defined in '$DFM_YAML'."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Create package dir if it doesn't exist."
    [before_test]="touch file1"
    [test]="dfm track pk1 file1  >& /dev/null && [ -d tests/packages/pk1 ]"
    [after_test]="rm file1 && rm -rf tests/packages/pk1"
    [expected_output]=""
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Track files"
    [before_test]="touch file1 file2"
    [test]="dfm track pk1 file1 file2 >& /dev/null && [ -f tests/packages/pk1/file1 ] && [ -f tests/packages/pk1/file2 ]"
    [after_test]="rm -rf tests/packages/pk1 >& /dev/null || rm file{1,2} >& /dev/null"
    [expected_output]=""
    [expected_status]=0
); run_test t

rm file{1,2} &> /dev/null
rm -rf tests/packages/pk1 &> /dev/null