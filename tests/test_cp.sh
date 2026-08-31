#!/bin/bash

set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOLUTION="$REPO_ROOT/starter/solution.sh"

# Create temporary directory
TMP_DIR="$(mktemp -d)"

# Clean up temporary directory when the test finishes
cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT

failures=0
score=0

pass() {
    echo "PASS: $1"
    score=$((score + $2))
}

fail() {
    echo "FAIL: $1"
    failures=$((failures + 1))
}

echo "=========================================="
echo " Linux cp Command Assignment - Autograder"
echo "=========================================="
echo

# ------------------------------------------------------------
# Check that solution.sh exists
# ------------------------------------------------------------

if [ ! -f "$SOLUTION" ]; then
    fail "starter/solution.sh does not exist"
    echo
    echo "Score: 0/100"
    exit 1
fi

# ------------------------------------------------------------
# Check that solution.sh is executable
# ------------------------------------------------------------

if [ ! -x "$SOLUTION" ]; then
    fail "starter/solution.sh is not executable"
    echo
    echo "Score: 0/100"
    exit 1
fi

# ------------------------------------------------------------
# Run student's solution
# ------------------------------------------------------------

echo "Running student solution..."
echo

if "$SOLUTION" "$TMP_DIR"; then
    pass "solution.sh executes successfully" 15
else
    fail "solution.sh returned a non-zero exit status"

    echo
    echo "Score: $score/100"
    exit 1
fi

# ------------------------------------------------------------
# Test 1: Single-file copy
# ------------------------------------------------------------

if [ -f "$TMP_DIR/file1.txt" ] &&
   [ -f "$TMP_DIR/file2.txt" ] &&
   cmp -s "$TMP_DIR/file1.txt" "$TMP_DIR/file2.txt"; then

    pass "Single file copied: file1.txt -> file2.txt" 20

else

    fail "Single-file copy is incorrect"

fi

# ------------------------------------------------------------
# Test 2: Copy file to directory
# ------------------------------------------------------------

if [ -f "$TMP_DIR/documents/file1.txt" ] &&
   cmp -s "$TMP_DIR/file1.txt" "$TMP_DIR/documents/file1.txt"; then

    pass "file1.txt copied to documents/" 20

else

    fail "file1.txt was not copied correctly to documents/"

fi

# ------------------------------------------------------------
# Test 3: Copy multiple files
# ------------------------------------------------------------

if [ -f "$TMP_DIR/documents/file1.txt" ] &&
   [ -f "$TMP_DIR/documents/file2.txt" ] &&
   cmp -s "$TMP_DIR/file1.txt" "$TMP_DIR/documents/file1.txt" &&
   cmp -s "$TMP_DIR/file2.txt" "$TMP_DIR/documents/file2.txt"; then

    pass "Multiple files copied to documents/" 20

else

    fail "Multiple-file copy to documents/ is incorrect"

fi

# ------------------------------------------------------------
# Test 4: Recursive directory copy
# ------------------------------------------------------------

if [ -d "$TMP_DIR/source_dir" ] &&
   [ -f "$TMP_DIR/source_dir/sample.txt" ] &&
   [ -d "$TMP_DIR/backup_dir" ] &&
   [ -f "$TMP_DIR/backup_dir/sample.txt" ] &&
   cmp -s "$TMP_DIR/source_dir/sample.txt" \
         "$TMP_DIR/backup_dir/sample.txt"; then

    pass "Directory copied recursively: source_dir -> backup_dir" 25

else

    fail "Recursive directory copy is incorrect"

fi

# ------------------------------------------------------------
# Display final result
# ------------------------------------------------------------

echo
echo "=========================================="
echo "Final Result"
echo "=========================================="

echo "Score: $score/100"

if [ "$failures" -eq 0 ]; then

    echo "All tests passed."
    exit 0

else

    echo "$failures test group(s) failed."
    exit 1

fi
