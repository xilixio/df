#!/bin/bash

# Test multi-file YAML support
# Note: Tests run with DFM_YAML=./tests/packages.yaml DFM_DOTFILES=./tests

# Setup: Create packages/ directory with test YAML files
setup_multifile() {
    rm -rf ./tests/packages_multi
    mkdir -p ./tests/packages_multi

    # Create dev.yaml
    cat > ./tests/packages_multi/dev.yaml << 'EOF'
packages:
  multi_dev1:
    Linux:
      install: "touch /tmp/multi_dev1.tmp"
      check: "[ -e /tmp/multi_dev1.tmp ]"
    Darwin:
      install: "touch /tmp/multi_dev1.tmp"
      check: "[ -e /tmp/multi_dev1.tmp ]"
  multi_dev2:
    Linux:
      deps:
        - multi_dev1
      install: "touch /tmp/multi_dev2.tmp"
      check: "[ -e /tmp/multi_dev2.tmp ]"
    Darwin:
      deps:
        - multi_dev1
      install: "touch /tmp/multi_dev2.tmp"
      check: "[ -e /tmp/multi_dev2.tmp ]"
EOF

    # Create shell.yaml
    cat > ./tests/packages_multi/shell.yaml << 'EOF'
packages:
  multi_shell1:
    Linux:
      install: "touch /tmp/multi_shell1.tmp"
      check: "[ -e /tmp/multi_shell1.tmp ]"
    Darwin:
      install: "touch /tmp/multi_shell1.tmp"
      check: "[ -e /tmp/multi_shell1.tmp ]"
EOF
}

# Setup for duplicate test
setup_duplicate() {
    rm -rf ./tests/packages_dup
    mkdir -p ./tests/packages_dup

    # Create file1.yaml with package 'dup_pkg'
    cat > ./tests/packages_dup/file1.yaml << 'EOF'
packages:
  dup_pkg:
    Linux:
      install: true
      check: false
    Darwin:
      install: true
      check: false
EOF

    # Create file2.yaml with same package 'dup_pkg'
    cat > ./tests/packages_dup/file2.yaml << 'EOF'
packages:
  dup_pkg:
    Linux:
      install: true
      check: false
    Darwin:
      install: true
      check: false
EOF
}

# Setup for invalid YAML test
setup_invalid() {
    rm -rf ./tests/packages_invalid
    mkdir -p ./tests/packages_invalid

    # Create valid.yaml
    cat > ./tests/packages_invalid/valid.yaml << 'EOF'
packages:
  valid_pkg:
    Linux:
      install: true
      check: false
    Darwin:
      install: true
      check: false
EOF

    # Create invalid.yaml (missing packages: key)
    cat > ./tests/packages_invalid/invalid.yaml << 'EOF'
something_else:
  not_packages: true
EOF
}

cleanup_multifile() {
    rm -rf ./tests/packages_multi
    rm -rf ./tests/packages_dup
    rm -rf ./tests/packages_invalid
    rm -f /tmp/multi_*.tmp
}

# Cleanup before tests
cleanup_multifile

# === Single File Mode Tests ===
# (These use the default tests/packages.yaml setup from Makefile)

declare -A t=(
    [description]="Single file mode: list still works"
    [test]="bin/dfm list -a | head -3"
    [expected_output]=$(cat <<EOF
pk1
pk2
pk3
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Single file mode: yaml command shows single file"
    [test]="bin/dfm yaml | grep packages"
    [expected_output]="./tests/packages.yaml (13 packages)"
    [expected_status]=0
); run_test t

# === Multi-file Mode Tests ===

declare -A t=(
    [description]="Multi-file mode: list shows packages from all files"
    [before_test]="setup_multifile"
    [test]="DFM_DOTFILES=./tests/packages_multi bin/dfm list -a"
    [expected_output]=$(cat <<EOF
multi_dev1
multi_dev2
multi_shell1
EOF
)
    [expected_status]=0
    [after_test]=""
); run_test t

declare -A t=(
    [description]="Multi-file mode: yaml command shows all sources"
    [before_test]="setup_multifile"
    [test]="DFM_DOTFILES=./tests/packages_multi bin/dfm yaml | grep -E '(sources:|packages)'"
    [expected_output]=$(cat <<EOF
Package sources:
  packages/dev.yaml           (2 packages)
  packages/shell.yaml         (1 packages)
EOF
)
    [expected_status]=0
    [after_test]=""
); run_test t

declare -A t=(
    [description]="Multi-file mode: check works across files"
    [before_test]="setup_multifile && touch /tmp/multi_shell1.tmp"
    [test]="DFM_DOTFILES=./tests/packages_multi bin/dfm check multi_shell1"
    [expected_output]="Package 'multi_shell1' is installed on Darwin."
    [expected_status]=0
    [after_test]="rm -f /tmp/multi_shell1.tmp"
); run_test t

declare -A t=(
    [description]="Multi-file mode: deps works across files"
    [before_test]="setup_multifile"
    [test]="DFM_DOTFILES=./tests/packages_multi bin/dfm deps multi_dev2"
    [expected_output]="multi_dev1"
    [expected_status]=0
    [after_test]=""
); run_test t

# === Duplicate Detection Tests ===

declare -A t=(
    [description]="Duplicate detection: error when same package in multiple files"
    [before_test]="setup_duplicate"
    [test]="DFM_DOTFILES=./tests/packages_dup bin/dfm list -a 2>&1 | grep -E '(Error|Duplicate)'"
    [expected_output]=$(cat <<EOF
Error: Duplicate package 'dup_pkg' found in:
EOF
)
    [expected_status]=0
    [after_test]=""
); run_test t

# === Invalid YAML Handling Tests ===

declare -A t=(
    [description]="Invalid YAML: warning shown, valid packages still listed"
    [before_test]="setup_invalid"
    [test]="DFM_DOTFILES=./tests/packages_invalid bin/dfm list -a 2>&1 | grep -v Warning"
    [expected_output]="valid_pkg"
    [expected_status]=0
    [after_test]=""
); run_test t

# === New Command Tests ===

declare -A t=(
    [description]="New command: requires -t flag in multi-file mode"
    [before_test]="setup_multifile"
    [test]="DFM_DOTFILES=./tests/packages_multi bin/dfm new testpkg 2>&1 | head -1"
    [expected_output]="Error: In multi-file mode, you must specify a target file with -t <file>."
    [expected_status]=1
    [after_test]=""
); run_test t

declare -A t=(
    [description]="New command: -t flag creates package in specified file"
    [before_test]="setup_multifile"
    [test]="DFM_DOTFILES=./tests/packages_multi bin/dfm new newpkg -t dev.yaml && yq '.packages | has(\"newpkg\")' < ./tests/packages_multi/dev.yaml"
    [expected_output]=$(cat <<EOF
Added 'newpkg' to './tests/packages_multi/dev.yaml'.
true
EOF
)
    [expected_status]=0
    [after_test]=""
); run_test t

declare -A t=(
    [description]="New command: -t flag creates new YAML file if needed"
    [before_test]="setup_multifile"
    [test]="DFM_DOTFILES=./tests/packages_multi bin/dfm new newpkg -t newfile.yaml && [ -f ./tests/packages_multi/newfile.yaml ] && echo 'file created'"
    [expected_output]=$(cat <<EOF
Created new YAML file './tests/packages_multi/newfile.yaml'.
Added 'newpkg' to './tests/packages_multi/newfile.yaml'.
file created
EOF
)
    [expected_status]=0
    [after_test]=""
); run_test t

declare -A t=(
    [description]="New command: prevents duplicate across files"
    [before_test]="setup_multifile"
    [test]="DFM_DOTFILES=./tests/packages_multi bin/dfm new multi_dev1 -t shell.yaml 2>&1"
    [expected_output]="Package 'multi_dev1' already exists in './tests/packages_multi/dev.yaml'."
    [expected_status]=1
    [after_test]=""
); run_test t

# === Edit Command Tests ===

declare -A t=(
    [description]="Edit command: lists files in multi-file mode"
    [before_test]="setup_multifile"
    [test]="DFM_DOTFILES=./tests/packages_multi bin/dfm edit 2>&1 | head -1"
    [expected_output]="Multiple YAML files available. Please specify which to edit:"
    [expected_status]=0
    [after_test]=""
); run_test t

# Cleanup after all tests
cleanup_multifile
