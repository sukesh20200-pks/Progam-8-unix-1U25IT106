#!/bin/bash

TMP_DIR="$1"

# Create test files and directories
echo "Hello World" > "$TMP_DIR/file1.txt"
echo "Second File" > "$TMP_DIR/file2.txt"

mkdir -p "$TMP_DIR/documents"

mkdir -p "$TMP_DIR/source_dir"
echo "Sample File" > "$TMP_DIR/source_dir/sample.txt"

# 1. Copy a single file
cp "$TMP_DIR/file1.txt" "$TMP_DIR/file2.txt"

# 2. Copy a file to a different directory
cp "$TMP_DIR/file1.txt" "$TMP_DIR/documents/"

# 3. Copy multiple files to a directory
cp "$TMP_DIR/file1.txt" "$TMP_DIR/file2.txt" "$TMP_DIR/documents/"

# 4. Copy a directory recursively
cp -r "$TMP_DIR/source_dir" "$TMP_DIR/backup_dir
