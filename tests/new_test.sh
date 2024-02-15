#!/bin/bash

# Before all
old_yaml="$DFM_YAML"

DFM_YAML1=$(mktemp)
DFM_YAML2=$(mktemp)

yaml_contents="$(cat <<EOF
packages:
EOF
)"
echo "$yaml_contents" > "$DFM_YAML1"
echo "$yaml_contents" > "$DFM_YAML2"

declare -A t=(
    [description]="Add new package to yaml."
    [test]="DFM_YAML=$DFM_YAML1 bin/dfm new test && cat \"$DFM_YAML1\""
    [expected_output]="$(cat <<EOF
Added 'test' to '$DFM_YAML1'.
packages:
  test:
    Linux:
      install: null
      check: null
    Darwin:
      install: null
      check: null
EOF
)"
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Add new package to yaml and create folder."
    [test]="DFM_YAML=$DFM_YAML2 bin/dfm new test -f && cat \"$DFM_YAML2\""
    [after_test]="rm -rf tests/packages &> /dev/null"
    [expected_output]="$(cat <<EOF
Added 'test' to '$DFM_YAML2'.
Created folder '$DFM_DOTFILES/packages/test'.
packages:
  test:
    Linux:
      install: null
      check: null
    Darwin:
      install: null
      check: null
EOF
)"
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Throw if package exists on yaml."
    [test]="bin/dfm new test && bin/dfm new test && cat \"$DFM_YAML\""
    [expected_output]="$(cat <<EOF
The package 'test' already exists in '$DFM_YAML'.
EOF
)"
    [expected_status]=1
); run_test t


# After all
rm "$DFM_YAML1" >/dev/null 2>&1
rm "$DFM_YAML2" >/dev/null 2>&1
DFM_YAML="$old_yaml"
rm -rf tests/packages &> /dev/null