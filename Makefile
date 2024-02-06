TESTS_DIR := ./tests
FRAMEWORK_TESTS_DIR := $(TESTS_DIR)/test_framework

test:
	$(TESTS_DIR)/run_tests.sh

test_framework_test:
	$(FRAMEWORK_TESTS_DIR)/test_framework_tests.sh

.PHONY: test test_framework_test