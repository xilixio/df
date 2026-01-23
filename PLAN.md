# DFM Improvement Plan

Each item is numbered for reference. Start a new Claude Code session with:
```
"Work on PLAN.md item P1-BASH-VERSION"
```

---

## Critical Priority

### P1-BASH-VERSION
**Bash 4.0+ compatibility issue**

- **Problem**: Scripts use `#!/bin/bash` but rely on Bash 4.0+ features (`declare -A`, `local -n`). macOS ships Bash 3.2.
- **Files**: `scripts/t` (line 93), `scripts/install` (line 9), all `tests/*_test.sh`
- **Evidence**: Test output shows `declare: -A: invalid option` and `local: -n: invalid option`
- **Solution options**:
  - A) Add version check at start of scripts, fail with clear message
  - B) Rewrite without associative arrays (use indexed arrays + parallel arrays)
  - C) Change shebang to `#!/usr/bin/env bash` and document Bash 4+ requirement
- **Recommendation**: Option A + C (check version, document requirement)

### P2-INSTALL-TEST-SYNTAX
**Syntax error in install_test.sh**

- **Problem**: Unclosed quote causes tests after line 257 to not parse on Linux
- **File**: `tests/install_test.sh:229-261`
- **Evidence**: `unexpected EOF while looking for matching '''`
- **Solution**: Fix the heredoc quoting around the `'$DFM_YAML'` expansion in expected output

### P3-TRACK-RACE-CONDITION
**TOCTOU race in track command**

- **Problem**: Gap between checking if file is tracked and moving it allows data loss
- **File**: `scripts/track:54-66`
- **Solution**: Use `mv -n` (no-clobber) or atomic operation pattern

---

## High Priority

### P4-BACKUP-CLEANUP
**Backup command doesn't clean up on failure**

- **Problem**: If commit fails after branch creation, empty backup branch remains
- **File**: `scripts/backup:21-41`
- **Solution**: Add branch deletion in error handlers before `git checkout "$original_branch"`

### P5-INSTALL-DFM-ARM
**install-dfm hardcodes amd64 architecture**

- **Problem**: Linux yq download uses `yq_linux_amd64`, fails on ARM
- **File**: `scripts/install-dfm:30`
- **Solution**: Detect architecture with `uname -m` and download appropriate binary

### P6-LINK-RELATIVE-SYMLINK
**link creates potentially broken symlinks**

- **Problem**: Symlink target path may be relative, breaking when accessed from other directories
- **File**: `scripts/link:78`
- **Solution**: Use `realpath "$sourcefile_path"` before `ln -s`

---

## Medium Priority

### P7-SHARED-VALIDATION
**Duplicated validation logic across scripts**

- **Problem**: Package name regex and YAML queries repeated in 8 files
- **Files**: `check`, `deps`, `install`, `link`, `islinked`, `track`, `new`, `list`
- **Solution**: Create `scripts/_common.sh` with shared functions:
  - `validate_package_name()`
  - `package_exists()`
  - `get_os_key()`
  - `yq_get()`

### P8-SILENT-FLAG-INCONSISTENCY
**Silent mode doesn't suppress prompts**

- **Problem**: `-s` flag doesn't skip confirmation prompts (needs `-y` separately)
- **File**: `scripts/install:91-92`
- **Solution**: Make `-s` imply `-y`, or document clearly that both are needed

### P9-LIST-PERFORMANCE
**dfm list -i is slow with many packages**

- **Problem**: Spawns new process for each package to check installation status
- **File**: `scripts/list:134-140`
- **Solution**: Batch check commands or cache results within single yq call

### P10-NEW-EXISTING-PACKAGE
**new command partially executes for existing packages**

- **Problem**: Skips YAML update but still creates directory/file
- **File**: `scripts/new:37-56`
- **Solution**: Check existence first, skip all operations or warn user

---

## Low Priority (Polish)

### P11-CONSISTENT-ERROR-PREFIX
**Inconsistent error message formatting**

- **Problem**: Some errors have "Error:" prefix, others don't
- **Files**: `link:18` vs `check:20`, `track:17`
- **Solution**: Standardize all error output to use "Error:" prefix

### P12-SUCCESS-MESSAGES
**Silent success on link and track commands**

- **Problem**: No feedback when operations succeed
- **Files**: `scripts/link:78-86`, `scripts/track:66-69`
- **Solution**: Add success message like "Linked 'file' to 'target'"

### P13-UNREACHABLE-CODE
**Dead code in check script**

- **Problem**: `exit 0` at line 72 is unreachable
- **File**: `scripts/check:72`
- **Solution**: Remove the unreachable line

### P14-INSTALL-DFM-FLOCK
**Flawed flock usage in install-dfm**

- **Problem**: Outer grep runs without lock, flock only protects inner grep
- **File**: `scripts/install-dfm:99-110`
- **Solution**: Restructure to hold lock for entire check-and-append operation

---

## Test Coverage Gaps

### T1-GIT-OPS-TESTS
**No tests for git operations**

- **Commands untested**: `push`, `pull`, `sync`, `diff`, `status`, `backup`, `update`
- **Solution**: Add test files using mock git repos in `/tmp`

### T2-INTEGRATION-TESTS
**No end-to-end workflow tests**

- **Missing**: Full workflow tests (new → track → link → push)
- **Solution**: Create `tests/integration_test.sh` with complete scenarios

### T3-EDGE-CASE-TESTS
**Missing edge case coverage**

- **Missing tests for**:
  - Paths with spaces
  - Very long package names (boundary testing)
  - Empty packages.yaml
  - Malformed YAML
  - Missing permissions on target directories

---

## Documentation

### D1-BASH-REQUIREMENT
**Document Bash 4+ requirement**

- **File**: `README.md:48`
- **Current**: "bash (4.0+ recommended)"
- **Change to**: "bash 4.0+ (required)" with installation instructions for macOS

### D2-DRY-RUN-FEATURE
**Add dry-run mode documentation** (if implemented)

- Dependent on implementing `--dry-run` flag for `install` and `track`

---

## Suggested Session Order

For maximum impact with minimal risk:

1. **P1-BASH-VERSION** - Fixes critical compatibility issue
2. **P2-INSTALL-TEST-SYNTAX** - Enables full test suite on Linux
3. **P7-SHARED-VALIDATION** - Reduces code duplication, makes other fixes easier
4. **P4-BACKUP-CLEANUP** - Prevents repository pollution
5. **P5-INSTALL-DFM-ARM** - Expands platform support
6. **T1-GIT-OPS-TESTS** - Increases confidence for future changes

---

## Checklist

- [x] P1-BASH-VERSION
- [x] P2-INSTALL-TEST-SYNTAX
- [ ] P3-TRACK-RACE-CONDITION
- [ ] P4-BACKUP-CLEANUP
- [ ] P5-INSTALL-DFM-ARM
- [ ] P6-LINK-RELATIVE-SYMLINK
- [ ] P7-SHARED-VALIDATION
- [ ] P8-SILENT-FLAG-INCONSISTENCY
- [ ] P9-LIST-PERFORMANCE
- [ ] P10-NEW-EXISTING-PACKAGE
- [ ] P11-CONSISTENT-ERROR-PREFIX
- [ ] P12-SUCCESS-MESSAGES
- [ ] P13-UNREACHABLE-CODE
- [ ] P14-INSTALL-DFM-FLOCK
- [ ] T1-GIT-OPS-TESTS
- [ ] T2-INTEGRATION-TESTS
- [ ] T3-EDGE-CASE-TESTS
- [ ] D1-BASH-REQUIREMENT
- [ ] D2-DRY-RUN-FEATURE
