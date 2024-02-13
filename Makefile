TEST_FRAMEWORK_DIR := ./test_framework
TESTS :=  check_test deps_test install_test list_test

test:
	DFM_YAML=./tests/packages.yaml scripts/t $(TESTS)
t:
	DFM_YAML=./tests/packages.yaml scripts/t $(TESTS)

t_test:
	DFM_YAML=./tests/packages.yaml scripts/t t_test

.PHONY: test t test_framework_test