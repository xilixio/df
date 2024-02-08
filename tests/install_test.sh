#!/bin/bash

os=$(uname -s)

# declare -A t=(
#     [description]="Throw if package doesn't exist."
#     [test]="bin/df install pkNoNo"
#     [expected_output]="Package 'pkNoNo' is not defined in 'packages.yaml'."
#     [expected_status]=1
# ); run_test t

# declare -A t=(
#     [description]="Silent throw if package doesn't exist."
#     [test]="bin/df install pkNoNo -s"
#     [expected_output]=""
#     [expected_status]=1
# ); run_test t

# declare -A t=(
#     [description]="Throw if package has cyclic dependencies"
#     [test]="bin/df install pkCD1"
#     [expected_output]="A cyclic dependency involving 'pkCD1' was found in the path '<root>->pkCD1->pkCD2->pkCD1'."
#     [expected_status]=1
# ); run_test t

# declare -A t=(
#     [description]="Silent throw if package has cyclic dependencies"
#     [test]="bin/df install pkCD1 -s"
#     [expected_output]=""
#     [expected_status]=1
# ); run_test t

# declare -A t=(
#     [description]="Throw if the current OS is not installed"
#     [test]="bin/df install pk_no_os"
#     [expected_output]="Package's 'pk_no_os' OS '$os' is not defined in 'packages.yaml'."
#     [expected_status]=1
# ); run_test t

# declare -A t=(
#     [description]="Silent throw if the current OS is not installed"
#     [test]="bin/df install pk_no_os -s"
#     [expected_output]=""
#     [expected_status]=1
# ); run_test t
# declare -A t=(
#     [description]="Throw if the 'check' entry is not defined in 'packages.yaml'"
#     [test]="bin/df install pk_no_check"
#     [expected_output]="Missing 'check' entry on 'packages.pk_no_check.$os' in 'packages.yaml'."
#     [expected_status]=1
# ); run_test t

# declare -A t=(
#     [description]="Silent throw if the 'check' entry is not defined in 'packages.yaml'"
#     [test]="bin/df install pk_no_check -s"
#     [expected_output]=""
#     [expected_status]=1
# ); run_test t

# declare -A t=(
#     [description]="Throw if the 'install' entry is not defined in 'packages.yaml'"
#     [test]="bin/df install pk_no_install"
#     [expected_output]="Missing 'install' entry on 'packages.pk_no_install.$os' in 'packages.yaml'."
#     [expected_status]=1
# ); run_test t

# declare -A t=(
#     [description]="Silent throw if the 'install' entry is not defined in 'packages.yaml'"
#     [test]="bin/df install pk_no_install -s"
#     [expected_output]=""
#     [expected_status]=1
# ); run_test t

# declare -A t=(
#     [description]="Throw if the package installation fails"
#     [test]="bin/df install pk_install_fail"
#     [expected_output]="Failed installing package 'pk_install_fail'. Error: Some error."
#     [expected_status]=1
# ); run_test t

# declare -A t=(
#     [description]="Silent throw if the package installation fails"
#     [test]="bin/df install pk_install_fail -s"
#     [expected_output]=""
#     [expected_status]=1
# ); run_test t

# declare -A t=(
#     [description]="Install package with no dependencies"
#     [test]="bin/df install pk3"
#     [after_test]="rm /tmp/pk3.tmp || true"
#     [expected_output]="Successfully installed package 'pk3'."
#     [expected_status]=0
# ); run_test t

# declare -A t=(
#     [description]="Silent install package with no dependencies"
#     [test]="bin/df install pk3 -s"
#     [after_test]="rm /tmp/pk3.tmp || true"
#     [expected_output]=""
#     [expected_status]=0
# ); run_test t

declare -A t=(
    [description]="Skip if package has been installed"
    [before_test]="touch /tmp/pk3.tmp"
    [test]="bin/df install pk3"
    [after_test]="rm /tmp/pk3.tmp || true"
    [expected_output]="Installing package 'pk3'... skipped."
    [expected_status]=0
); run_test t

declare -A t=(
    [description]="Silend skip if package has been installed"
    [before_test]="touch /tmp/pk3.tmp"
    [test]="bin/df install pk3 -s"
    [after_test]="rm /tmp/pk3.tmp || true"
    [expected_output]=""
    [expected_status]=0
); run_test t

# declare -A t=(
#     [description]="Install package and its dependencies"
#     [test]="bin/df install pk1 -y && 
#             bin/df check pk1 -s && \
#             bin/df check pk2 -s && \
#             bin/df check pk3 -s"
#     [after_test]="rm /tmp/pk1.tmp || /tmp/pk2.tmp || /tmp/pk3.tmp || true"
#     [expected_output]=$(cat <<EOF
# Successfully installed package 'pk3'.
# Successfully installed package 'pk2'.
# Successfully installed package 'pk1'.
# EOF
#     )
#     [expected_status]=0
# ); run_test t

# declare -A t=(
#     [description]="Silent install package and its dependencies"
#     [test]="bin/df install pk1 -s -y && 
#             bin/df check pk1 -s && \
#             bin/df check pk2 -s && \
#             bin/df check pk3 -s"
#     [after_test]="rm /tmp/pk1.tmp || /tmp/pk2.tmp || /tmp/pk3.tmp || true"
#     [expected_output]=""
#     [expected_status]=0
# ); run_test t