#!/usr/bin/env bash
# Requires Bash 4.0+ (associative arrays)
# Tests for P1-BASH-VERSION and P5-INSTALL-DFM-ARM

# P1-BASH-VERSION: Verify test runner checks bash version
declare -A t=(
    [description]="P1: Test runner has bash version check"
    [test]="grep -q 'BASH_VERSINFO\[0\] < 4' scripts/t"
    [expected_output]=""
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="P1: Test runner uses env bash shebang"
    [test]="head -1 scripts/t | grep -q '#!/usr/bin/env bash'"
    [expected_output]=""
    [expected_status]=0
); run_test t

# P5-INSTALL-DFM-ARM: Verify architecture detection exists
declare -A t=(
    [description]="P5: install-dfm detects x86_64/amd64 architecture"
    [test]="grep -q 'x86_64|amd64' scripts/install-dfm"
    [expected_output]=""
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="P5: install-dfm detects aarch64/arm64 architecture"
    [test]="grep -q 'aarch64|arm64' scripts/install-dfm"
    [expected_output]=""
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="P5: install-dfm detects armv7l/armv6l/arm architecture"
    [test]="grep -q 'armv7l|armv6l|arm' scripts/install-dfm"
    [expected_output]=""
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="P5: install-dfm detects i386/i686 architecture"
    [test]="grep -q 'i386|i686' scripts/install-dfm"
    [expected_output]=""
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="P5: install-dfm uses uname -m for architecture detection"
    [test]="grep -q 'uname -m' scripts/install-dfm"
    [expected_output]=""
    [expected_status]=0
); run_test t
