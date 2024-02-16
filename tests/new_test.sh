#!/bin/bash

# Before all
old_yaml="$DFM_YAML"

DFM_YAML1=$(mktemp)
DFM_YAML2=$(mktemp)
DFM_YAML3=$(mktemp)

yaml_contents="$(cat <<EOF
packages:
EOF
)"
echo "$yaml_contents" > "$DFM_YAML1"
echo "$yaml_contents" > "$DFM_YAML2"
echo "$yaml_contents" > "$DFM_YAML3"

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
    [description]="Add new package to yaml and create directory."
    [test]="DFM_YAML=$DFM_YAML2 bin/dfm new test -d && cat \"$DFM_YAML2\" && [ -d \"$DFM_DOTFILES/packages/test\" ]"
    [after_test]="rm -rf $DFM_DOTFILES/packages &> /dev/null"
    [expected_output]="$(cat <<EOF
Added 'test' to '$DFM_YAML2'.
Created directory '$DFM_DOTFILES/packages/test'.
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
    [description]="Add new package to yaml, create directory, and create executable."
    [test]="DFM_YAML=$DFM_YAML3 bin/dfm new test -df && [ -d \"$DFM_DOTFILES/packages/test\" ]  && [ -f \"$DFM_DOTFILES/packages/test/test.sh\" ]"
    [after_test]="rm -rf $DFM_DOTFILES/packages &> /dev/null"
    [expected_output]="$(cat <<EOF
Added 'test' to '$DFM_YAML3'.
Created directory '$DFM_DOTFILES/packages/test'.
Created executable '$DFM_DOTFILES/packages/test/test.sh'.
EOF
)"
    [expected_status]=0
); run_test t

# After all
rm "$DFM_YAML1" >/dev/null 2>&1
rm "$DFM_YAML2" >/dev/null 2>&1
rm "$DFM_YAML3" >/dev/null 2>&1
DFM_YAML="$old_yaml"
rm -rf "$DFM_DOTFILES/packages" &> /dev/null