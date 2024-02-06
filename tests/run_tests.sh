#!/bin/bash
dir=$(dirname "$(readlink -f "$0")")
source "$dir/test_framework/test_framework.sh"
source "$dir/list_test.sh"

test_summary