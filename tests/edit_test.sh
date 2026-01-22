#!/bin/bash

# Tests for the edit command

declare -A t=(
    [description]="Edit fails when DFM_YAML is not set"
    [test]="DFM_YAML= bin/dfm edit 2>&1"
    [expected_output]="The DFM_YAML variable is not set. Exiting."
    [expected_status]=1
); run_test t
