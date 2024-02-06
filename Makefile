TEST_FRAMEWORK_DIR := ./test_framework

test:
	$(TEST_FRAMEWORK_DIR)/test_runner.sh list_test

test_framework_test:
	$(TEST_FRAMEWORK_DIR)/test_runner.sh test_framework/test_framework_tests

.PHONY: test test_framework_test