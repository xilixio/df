#!/bin/bash

# Tests for package name validation (security fix)
# Package names should only contain letters, numbers, and underscores

# Test check command with invalid package names
declare -A t=(
    [description]="Check rejects package names with hyphens"
    [test]="bin/dfm check test-pkg"
    [expected_output]="Invalid package name 'test-pkg'. Package names must contain only letters, numbers, and underscores."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Check rejects package names with spaces"
    [test]="bin/dfm check 'test pkg'"
    [expected_output]="Invalid package name 'test pkg'. Package names must contain only letters, numbers, and underscores."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Check rejects package names with special characters"
    [test]="bin/dfm check 'test;echo'"
    [expected_output]="Invalid package name 'test;echo'. Package names must contain only letters, numbers, and underscores."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Check rejects package names with backticks"
    [test]='bin/dfm check "test\`id\`"'
    [expected_output]="Invalid package name 'test\`id\`'. Package names must contain only letters, numbers, and underscores."
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Check accepts valid package names with underscores"
    [test]="bin/dfm check pk_valid 2>&1 | head -1"
    [expected_output]="Package 'pk_valid' is not defined in '$DFM_YAML'."
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Check accepts valid package names with numbers"
    [test]="bin/dfm check pk123 2>&1 | head -1"
    [expected_output]="Package 'pk123' is not defined in '$DFM_YAML'."
    [expected_status]=0
); run_test t

# Test deps command with invalid package names
declare -A t=(
    [description]="Deps rejects package names with hyphens"
    [test]="bin/dfm deps test-pkg"
    [expected_output]="Invalid package name 'test-pkg'. Package names must contain only letters, numbers, and underscores."
    [expected_status]=1
); run_test t

# Test link command with invalid package names
declare -A t=(
    [description]="Link rejects package names with special characters"
    [test]="bin/dfm link 'test\$var' file target"
    [expected_output]="Error: Invalid package name 'test\$var'. Package names must contain only letters, numbers, and underscores."
    [expected_status]=1
); run_test t

# Test track command with invalid package names
declare -A t=(
    [description]="Track rejects package names with hyphens"
    [test]="bin/dfm track test-pkg /tmp/file"
    [expected_output]="Invalid package name 'test-pkg'. Package names must contain only letters, numbers, and underscores."
    [expected_status]=1
); run_test t

# Test new command with invalid package names
declare -A t=(
    [description]="New rejects package names with hyphens"
    [test]="bin/dfm new test-pkg"
    [expected_output]="Invalid package name 'test-pkg'. Package names must contain only letters, numbers, and underscores."
    [expected_status]=1
); run_test t
