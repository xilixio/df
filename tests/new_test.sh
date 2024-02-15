#!/bin/bash

# Before all
old_yaml="$DFM_YAML"
DFM_YAML=$(mktemp)
"$(cat <<EOF
packages:
EOF
)" > "$DFM_YAML"

declare -A t=(
    [description]="Add new package to yaml."
    [test]="bin/dfm new test && cat \"$DFM_YAML\""
    [expected_output]="$(cat <<EOF
Added 'test' to '$DFM_YAML'.
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
rm temp_file >/dev/null 2>&1
DFM_YAML="$old_yaml"