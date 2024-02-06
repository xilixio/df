#!/bin/bash

# Check if any arguments were passed
if [ "$#" -eq 0 ]; then
    echo "No arguments provided."
    echo "Usage: $0 test1 [test2 ...]"
    exit 1
fi

test_framework_dir="$PWD/test_framework"
tests_dir="$PWD/tests"
source "$test_framework_dir/test_framework.sh"

# Iterate over all passed arguments
for arg in "$@"; do
    test_file="${arg}.sh"

    # Check if the script file exists and is readable
    if [ -r "$tests_dir/$test_file" ]; then
        source "$tests_dir/$test_file"
    else
        echo "Warning: Testfile '$tests_dir/$test_file' not found or not readable."
    fi
done

test_summary