#!/usr/bin/env bash
# Requires Bash 4.0+ (associative arrays)

# Tests for the edit command

declare -A t=(
    [description]="Edit fails when DFM_YAML is not set"
    [test]="DFM_YAML= bin/dfm edit 2>&1"
    [expected_output]="Error: DFM_YAML file '' doesn't exist. Please create a packages.yaml file in your dotfiles directory."
    [expected_status]=1
); run_test t
