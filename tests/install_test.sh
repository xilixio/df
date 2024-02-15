#!/bin/bash

os=$(uname -s)

# Before all
rm /tmp/pk{1,2,3}.tmp >/dev/null 2>&1

declare -A t=(
    [description]="Throw if package doesn't exist."
    [test]="bin/dfm install pkNoNo -y"
    [expected_output]=$(cat <<EOF
About to install the following packages: pkNoNo 
Package 'pkNoNo' is not defined in '$DFM_YAML'.
EOF
)
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Silent throw if package doesn't exist."
    [test]="bin/dfm install pkNoNo -y -s"
    [expected_output]=""
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if package has cyclic dependencies"
    [test]="bin/dfm install pkCD1 -y"
    [expected_output]=$(cat <<EOF
About to install the following packages: pkCD1 
A cyclic dependency involving 'pkCD1' was found in the path '<root>->pkCD1->pkCD2->pkCD1'.
EOF
)
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Silent throw if package has cyclic dependencies"
    [test]="bin/dfm install pkCD1 -y -s"
    [expected_output]=""
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if the current OS is not installed"
    [test]="bin/dfm install pk_no_os -y"
    [expected_output]=$(cat <<EOF
About to install the following packages: pk_no_os 
Package's 'pk_no_os' OS '$os' is not defined in '$DFM_YAML'.
EOF
)
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Silent throw if the current OS is not installed"
    [test]="bin/dfm install pk_no_os -y -s"
    [expected_output]=""
    [expected_status]=1
); run_test t
declare -A t=(
    [description]="Throw if the 'check' entry is not defined in '$DFM_YAML'"
    [test]="bin/dfm install pk_no_check -y"
    [expected_output]=$(cat <<EOF
About to install the following packages: pk_no_check 
Missing 'check' entry on 'packages.pk_no_check.$os' in '$DFM_YAML'.
EOF
)
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Silent throw if the 'check' entry is not defined in '$DFM_YAML'"
    [test]="bin/dfm install pk_no_check -y -s"
    [expected_output]=""
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if the 'install' entry is not defined in '$DFM_YAML'"
    [test]="bin/dfm install pk_no_install -y"
    [expected_output]=$(cat <<EOF
About to install the following packages: pk_no_install 
Missing 'install' entry on 'packages.pk_no_install.$os' in '$DFM_YAML'.
EOF
)
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Silent throw if the 'install' entry is not defined in '$DFM_YAML'"
    [test]="bin/dfm install pk_no_install -y -s"
    [expected_output]=""
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Throw if the package installation fails"
    [test]="bin/dfm install pk_install_fail -y"
    [expected_output]=$(cat <<EOF
About to install the following packages: pk_install_fail 
Installing package 'pk_install_fail'...
Failed installing package 'pk_install_fail'. Error: Some error.
EOF
)
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Silent throw if the package installation fails"
    [test]="bin/dfm install pk_install_fail -y -s"
    [expected_output]=""
    [expected_status]=1
); run_test t

declare -A t=(
    [description]="Install package with no dependencies"
    [test]="bin/dfm install pk3 -y"
    [after_test]="rm /tmp/pk3.tmp || true"
    [expected_output]=$(cat <<EOF
About to install the following packages: pk3 
Installing package 'pk3'...
Successfully installed package 'pk3'.
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Silent install package with no dependencies"
    [test]="bin/dfm install pk3 -y -s"
    [after_test]="rm /tmp/pk3.tmp || true"
    [expected_output]=""
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Skip if package has been installed"
    [before_test]="touch /tmp/pk3.tmp"
    [test]="bin/dfm install pk3 -y"
    [after_test]="rm /tmp/pk3.tmp || true"
    [expected_output]=$(cat <<EOF
About to install the following packages: pk3 
Installing package 'pk3'...
Package 'pk3' was already installed, skipping.
EOF
)
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Silent skip if package has been installed"
    [before_test]="touch /tmp/pk3.tmp"
    [test]="bin/dfm install pk3 -y -s"
    [after_test]="rm /tmp/pk3.tmp || true"
    [expected_output]=""
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Install package and its dependencies"
    [test]="bin/dfm install pk1 -y && 
            bin/dfm check pk1 -s && \
            bin/dfm check pk2 -s && \
            bin/dfm check pk3 -s"
    [after_test]="rm /tmp/pk{1,2,3}.tmp || true"
    [expected_output]=$(cat <<EOF
About to install the following packages: pk1 
Installing package 'pk3'...
Successfully installed package 'pk3'.
Installing package 'pk2'...
Successfully installed package 'pk2'.
Installing package 'pk1'...
Successfully installed package 'pk1'.
EOF
    )
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Silent install package and its dependencies"
    [test]="bin/dfm install pk1 -s -y && 
            bin/dfm check pk1 -s && \
            bin/dfm check pk2 -s && \
            bin/dfm check pk3 -s"
    [after_test]="rm /tmp/pk{1,2,3}.tmp || true"
    [expected_output]=""
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Install multiple package and its dependencies"
    [test]="bin/dfm install pk3 pk1 -y && 
            bin/dfm check pk1 -s && \
            bin/dfm check pk2 -s && \
            bin/dfm check pk3 -s"
    [after_test]="rm /tmp/pk{1,2,3}.tmp || true"
    [expected_output]=$(cat <<EOF
About to install the following packages: pk3 pk1 
Installing package 'pk3'...
Successfully installed package 'pk3'.
Installing package 'pk2'...
Successfully installed package 'pk2'.
Installing package 'pk1'...
Successfully installed package 'pk1'.
EOF
    )
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Silent install multiple package and its dependencies"
    [test]="bin/dfm install pk3 pk1 -s -y && 
            bin/dfm check pk1 -s && \
            bin/dfm check pk2 -s && \
            bin/dfm check pk3 -s"
    [after_test]="rm /tmp/pk{1,2,3}.tmp || true"
    [expected_output]=""
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Install all and ignore errors"
    [test]="bin/dfm install -y -i && 
            bin/dfm check pk1 -s && \
            bin/dfm check pk2 -s && \
            bin/dfm check pk3 -s"
    [after_test]="rm /tmp/pk{1,2,3}.tmp || true"
    [expected_output]=$(cat <<EOF
About to install the following packages: pk1 pk2 pk3 pk_no_check pk_no_install pkCD1 pkCD2 pk_install_fail 
Installing package 'pk3'...
Successfully installed package 'pk3'.
Installing package 'pk2'...
Successfully installed package 'pk2'.
Installing package 'pk1'...
Successfully installed package 'pk1'.
Missing 'check' entry on 'packages.pk_no_check.Linux' in '$DFM_YAML'.
Package 'pk_no_check' has validation errors, ignoring.
Missing 'install' entry on 'packages.pk_no_install.Linux' in '$DFM_YAML'.
Package 'pk_no_install' has validation errors, ignoring.
A cyclic dependency involving 'pkCD1' was found in the path '<root>->pkCD1->pkCD2->pkCD1'.
Package 'pkCD1' has validation errors, ignoring.
Installing package 'pkCD2'...
Successfully installed package 'pkCD2'.
Installing package 'pkCD1'...
Successfully installed package 'pkCD1'.
A cyclic dependency involving 'pkCD2' was found in the path '<root>->pkCD2->pkCD1->pkCD2'.
Package 'pkCD2' has validation errors, ignoring.
Installing package 'pk_install_fail'...
Failed installing package 'pk_install_fail'. Error: Some error.
Package 'pk_install_fail' has validation errors, ignoring.
EOF
    )
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Silent install all and ignore errors"
    [test]="bin/dfm install -y -i -s &&
            bin/dfm check pk1 -s && \
            bin/dfm check pk2 -s && \
            bin/dfm check pk3 -s"
    [after_test]="rm /tmp/pk{1,2,3}.tmp || true"
    [expected_output]=""
    [expected_status]=0
); run_test t

# After all
rm /tmp/pk{1,2,3}.tmp >/dev/null 2>&1