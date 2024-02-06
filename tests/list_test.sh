#!/bin/bash

declare -A t=(
    [description]="List all packages in plaintext"
    [test]="bin/df list"
    [expected_output]=$(cat <<EOF
pk1
pk2
pk3
pk_no_os
pk_no_check
EOF
)
    [expected_status]=0
); run_test t

