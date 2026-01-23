#!/usr/bin/env bash
# Requires Bash 4.0+ (associative arrays)

os=$(uname -s)

# Before all
rm /tmp/pk{1,2,3}.tmp >/dev/null 2>&1

declare -A t=(
    [description]="Throw if -a and -o are set"
    [test]="bin/dfm list -a -o Linux"
    [expected_output]="Cannot set -a with -o or -s"
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if -a and -s are set"
    [test]="bin/dfm list -a -s true"
    [expected_output]="Cannot set -a with -o or -s"
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="List all packages defined in packages.yaml"
    [test]="bin/dfm list -a"
    [expected_output]=$(cat <<EOF
pk1
pk2
pk3
pk4
pk_no_os
pk_no_check
pk_no_install
pkCD1
pkCD2
pk_install_fail
test
brew
brew_packages
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List packages for the current OS ($os)"
    [test]="bin/dfm list"
    [expected_output]=$(cat <<EOF
pk1
pk2
pk3
pk_no_check
pk_no_install
pkCD1
pkCD2
pk_install_fail
test
brew
brew_packages
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List packages for a specific OS (Darwin)"
    [before_test]=""
    [test]="bin/dfm list -o Darwin"
    [after_test]=""
    [expected_output]=$(cat <<EOF
pk1
pk2
pk4
pk_no_check
pk_no_install
pkCD1
pkCD2
pk_install_fail
test
brew
brew_packages
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List all installed packages for the current OS ($os)"
    [before_test]="touch /tmp/pk1.tmp"
    [test]="bin/dfm list -s true"
    [after_test]="rm /tmp/pk1.tmp"
    [expected_output]=$(cat <<EOF
pk1
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List all packages NOT installed for the current OS ($os)"
    [before_test]="touch /tmp/pk1.tmp"
    [test]="bin/dfm list -s false"
    [after_test]="rm /tmp/pk1.tmp"
    [expected_output]=$(cat <<EOF
pk2
pk3
pk_no_check
pk_no_install
pkCD1
pkCD2
pk_install_fail
test
brew
brew_packages
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List all installed packages for a specific OS (Darwin)"
    [before_test]="touch /tmp/pk2.tmp"
    [test]="bin/dfm list -s true -o Darwin"
    [after_test]="rm /tmp/pk2.tmp"
    [expected_output]=$(cat <<EOF
pk2
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List all packages NOT installed for a specific OS (Darwin)"
    [before_test]="touch /tmp/pk2.tmp"
    [test]="bin/dfm list -s false -o Darwin"
    [after_test]="rm /tmp/pk2.tmp"
    [expected_output]=$(cat <<EOF
pk1
pk4
pk_no_check
pk_no_install
pkCD1
pkCD2
pk_install_fail
test
brew
brew_packages
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List all packages with info"
    [before_test]="touch /tmp/pk2.tmp"
    [test]="bin/dfm list -i -a"
    [after_test]="rm /tmp/pk2.tmp"
    [expected_output]=$(cat <<EOF
pk1 Linux,Darwin not_installed
pk2 Linux,Darwin installed
pk3 Linux not_installed
pk4 Darwin not_installed
pk_no_os <empty> not_installed
pk_no_check Linux,Darwin not_installed
pk_no_install Linux,Darwin not_installed
pkCD1 Linux,Darwin not_installed
pkCD2 Linux,Darwin not_installed
pk_install_fail Linux,Darwin not_installed
test Linux,Darwin not_installed
brew Linux,Darwin not_installed
brew_packages Linux,Darwin not_installed
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List installed packages with info for current OS (Linux)"
    [before_test]="touch /tmp/pk2.tmp"
    [test]="bin/dfm list -i -s true"
    [after_test]="rm /tmp/pk2.tmp"
    [expected_output]=$(cat <<EOF
pk2 Linux,Darwin installed
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List NOT installed packages with info for current OS (Linux)"
    [before_test]="touch /tmp/pk2.tmp"
    [test]="bin/dfm list -i -s false"
    [after_test]="rm /tmp/pk2.tmp"
    [expected_output]=$(cat <<EOF
pk1 Linux,Darwin not_installed
pk3 Linux not_installed
pk_no_check Linux,Darwin not_installed
pk_no_install Linux,Darwin not_installed
pkCD1 Linux,Darwin not_installed
pkCD2 Linux,Darwin not_installed
pk_install_fail Linux,Darwin not_installed
test Linux,Darwin not_installed
brew Linux,Darwin not_installed
brew_packages Linux,Darwin not_installed
EOF
)
    [expected_status]=0
); run_test t

# After all
rm /tmp/pk{1,2,3}.tmp >/dev/null 2>&1