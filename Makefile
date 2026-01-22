TEST_FRAMEWORK_DIR := ./test_framework
TESTS := check_test deps_test install_test list_test new_test track_test islinked_test link_test edit_test validation_test

test:
	DFM_YAML=./tests/packages.yaml DFM_DOTFILES=./tests scripts/t $(TESTS)
t:
	DFM_YAML=./tests/packages.yaml DFM_DOTFILES=./tests scripts/t $(TESTS)

t_test:
	DFM_YAML=./tests/packages.yaml DFM_DOTFILES=./tests scripts/t t_test

.PHONY: test t test_framework_test