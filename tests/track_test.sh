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

# P3-TRACK-RACE-CONDITION: Test that mv -n prevents overwriting existing files
declare -A t=(
    [description]="P3: Prevent overwriting existing tracked file (race condition fix)"
    [before_test]="mkdir -p tests/packages/pk1 && echo 'original' > tests/packages/pk1/file1 && echo 'new' > file1"
    [test]="dfm track pk1 file1 2>&1"
    [after_test]="content=\$(cat tests/packages/pk1/file1); rm -f file1; rm -rf tests/packages/pk1; [ \"\$content\" = 'original' ]"
    [expected_output]="Error: Cannot track 'file1' - destination '$DFM_DOTFILES/packages/pk1/file1' already exists."
    [expected_status]=1
); run_test t

rm -f file1 &> /dev/null
rm -rf tests/packages/pk1 &> /dev/null