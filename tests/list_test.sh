#!/bin/bash

os=$(uname -s)

declare -A t=(
    [description]="List all packages in plaintext"
    [test]="bin/df list"
    [expected_output]=$(cat <<EOF
pk1
pk2
pk3
pk_no_check
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List all packages for the current OS ($os)"
    [before_test]=""
    [test]="bin/df list"
    [after_test]=""
    [expected_output]=$(cat <<EOF
pk1
pk2
pk3
pk_no_check
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List all packages for a specific OS (Darwin)"
    [before_test]=""
    [test]="bin/df list -o Darwin"
    [after_test]=""
    [expected_output]=$(cat <<EOF
pk1
pk2
pk_no_check
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List all installed packages for the current OS ($os)"
    [before_test]="touch /tmp/pk1.tmp"
    [test]="bin/df list -i true"
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
    [test]="bin/df list -i false"
    [after_test]="rm /tmp/pk1.tmp"
    [expected_output]=$(cat <<EOF
pk2
pk3
pk_no_check
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List all installed packages for a specific OS (Darwin)"
    [before_test]="touch /tmp/pk2.tmp"
    [test]="bin/df list -i true -o Darwin"
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
    [test]="bin/df list -i false -o Darwin"
    [after_test]="rm /tmp/pk2.tmp"
    [expected_output]=$(cat <<EOF
pk1
pk_no_check
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="List all packages in rich text"
    [before_test]="touch /tmp/pk2.tmp"
    [test]="bin/df list -a"
    [after_test]="rm /tmp/pk2.tmp"
    [expected_output]=$(cat <<EOF
pk1 ( Linux Darwin ) [Not installed]
  Deps: pk2 pk3 
pk2 ( Linux Darwin ) [Installed]
  Deps: pk3 
pk3 ( Linux ) [Not installed]
  Deps: <none>
pk_no_check ( Linux Darwin ) [Not installed]
  Deps: <none>
EOF
)
    [expected_status]=0
); run_test t