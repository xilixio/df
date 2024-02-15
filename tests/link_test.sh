#!/bin/bash

declare -A t=(
    [description]="Throw if package is not defined"
    [before_test]=""
    [test]="dfm link xx sourcef targetf"
    [after_test]=""
    [expected_output]="Error: Package 'xx' is not defined in '$DFM_YAML'."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if package doesn't have a folder"
    [before_test]=""
    [test]="dfm link pk1 sourcef targetf"
    [after_test]=""
    [expected_output]="Error: Package 'pk1' doesn't have a corresponding folder 'packages/pk1'."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if source file doesn't exist"
    [before_test]="mkdir -p tests/packages/pk1"
    [test]="dfm link pk1 sourcef targetf"
    [after_test]="rm -rf tests/packages/pk1 &> /dev/null"
    [expected_output]="Error: Source file '$DFM_DOTFILES/packages/pk1/sourcef' doesn't exist."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Link source file to target file"
    [before_test]="mkdir -p tests/packages/pk1 && touch tests/packages/pk1/sourcef"
    [test]="dfm link pk1 sourcef targetf"
    [after_test]="rm targetf* &> /dev/null || rm -rf tests/packages/pk1 &> /dev/null"
    [expected_output]=""
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Throw if target file is already linked"
    [before_test]="mkdir -p tests/packages/pk1 && touch tests/packages/pk1/sourcef && dfm link pk1 sourcef targetf"
    [test]="dfm link pk1 sourcef targetf"
    [after_test]="rm targetf* &> /dev/null || rm -rf tests/packages/pk1 &> /dev/null"
    [expected_output]="Error: Target file 'targetf' is already linked."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if sourcef is not within package path"
    [before_test]="mkdir -p tests/packages/pk1 && touch tests/packages/sourcef"
    [test]="dfm link pk1 ../sourcef targetf"
    [after_test]="rm targetf* &> /dev/null || rm -rf tests/packages/pk1 &> /dev/null"
    [expected_output]="Error: Source file's real path '$(realpath "$DFM_DOTFILES")/packages' is not within the package's path '$(realpath "$DFM_DOTFILES")/packages/pk1'"
    [expected_status]=1
); run_test t

# declare -A t=(
#     [description]="Backup if targetf already exists"
#     [before_test]="mkdir -p tests/packages/pk1 && touch tests/packages/pk1/sourcef && touch targetf"
#     [test]="dfm link pk1 sourcef targetf && [ -f targetf.bak* ]"
#     [after_test]="rm targetf* &> /dev/null || rm -rf tests/packages/pk1 &> /dev/null"
#     [expected_output]=""
#     [expected_status]=0
# ); run_test t

rm targetf* &> /dev/null
rm -rf tests/packages &> /dev/null