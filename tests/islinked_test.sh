#!/bin/bash

declare -A t=(
    [description]="Throw if package doesn't exist"
    [before_test]=""
    [test]="dfm islinked xx targetf"
    [after_test]=""
    [expected_output]="Error: Package 'xx' is not defined in '$DFM_YAML'."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if target file doesn't exist"
    [before_test]=""
    [test]="dfm islinked pk1 targetf"
    [after_test]=""
    [expected_output]="Error: Target file 'targetf' doesn't exist."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if target file is not a symlink"
    [before_test]="touch targetf"
    [test]="dfm islinked pk1 targetf"
    [after_test]="rm targetf &> /dev/null"
    [expected_output]="Error: Target file 'targetf' is not a symlink."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if package doesn't have a folder"
    [before_test]="touch sourcef && ln -s sourcef targetf"
    [test]="dfm islinked pk1 targetf"
    [after_test]="rm targetf &> /dev/null || rm sourcef &> /dev/null"
    [expected_output]="Error: Package 'pk1' doesn't have a corresponding folder 'packages/pk1'"
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if target file's path is not within the package's path"
    [before_test]="touch sourcef && ln -s sourcef targetf && mkdir -p tests/packages/pk1"
    [test]="dfm islinked pk1 targetf"
    [after_test]="rm targetf &> /dev/null || rm sourcef &> /dev/null || rm -rf tests/packages"
    [expected_output]="Error: Target file's real path '$(realpath sourcef)' is not within the package's path '$(realpath "$DFM_DOTFILES")/packages/pk1'."
    [expected_status]=1
); run_test t

rm sourcef &> /dev/null
rm targetf &> /dev/null
rm -rf tests/packages &> /dev/null