#!/bin/bash

declare -A t=(
    [description]="List all packages in plaintext"
    [command]="bin/list"
    [expected_output]=$(cat <<EOF
pk1
pk2
pk3
EOF
)
    [expected_status]=0
); run_test t

