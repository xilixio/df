TEST_FRAMEWORK_DIR := ./test_framework
TESTS :=  list_test check_test

test:
	$(TEST_FRAMEWORK_DIR)/test_runner.sh $(TESTS)
t:
	$(TEST_FRAMEWORK_DIR)/test_runner.sh $(TESTS)

test_framework_test:
	$(TEST_FRAMEWORK_DIR)/test_runner.sh test_framework/test_framework_tests

.PHONY: test t test_framework_test