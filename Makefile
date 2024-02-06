TEST_FRAMEWORK_DIR := ./test_framework
TESTS :=  list_test check_test

test:
	bin/t $(TESTS)
t:
	bin/t $(TESTS)

t_test:
	bin/t t_test

.PHONY: test t test_framework_test