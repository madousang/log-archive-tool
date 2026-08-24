#!/bin/bash

# log-archive.sh - Archive logs from a given directory into a timestamped tar.gz

set -euo pipefail

# --- Config ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCHIVE_DIR="${ARCHIVE_DIR:-$SCRIPT_DIR/archive-output}"
LOG_FILE="${LOG_FILE:-$SCRIPT_DIR/archive.log}"

# --- Argument check ---
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <log-directory>"
    exit 1
fi

LOG_DIR="$1"

if [ ! -d "$LOG_DIR" ]; then
    echo "Error: '$LOG_DIR' is not a valid directory."
    exit 1
fi

mkdir -p "$(dirname "$LOG_FILE")" "$ARCHIVE_DIR"

# Prevent archiving a directory into itself or a child of itself.
if [ "$LOG_DIR" = "$ARCHIVE_DIR" ] || [[ "$LOG_DIR" == "$ARCHIVE_DIR"/* ]] || [[ "$ARCHIVE_DIR" == "$LOG_DIR"/* ]]; then
    echo "Error: archive directory '$ARCHIVE_DIR' must not be inside or equal to '$LOG_DIR'."
    exit 1
fi

# --- Prepare archive destination ---
mkdir -p "$ARCHIVE_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="$ARCHIVE_DIR/$ARCHIVE_NAME"

# --- Compress logs ---
tar -czf "$ARCHIVE_PATH" -C "$(dirname "$LOG_DIR")" "$(basename "$LOG_DIR")"

# --- Verify and log ---
if [ $? -eq 0 ] && [ -f "$ARCHIVE_PATH" ]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Archived '$LOG_DIR' -> $ARCHIVE_NAME" >> "$LOG_FILE" 
    find "$ARCHIVE_DIR" -name "logs_archive_*.tar.gz" -mtime +30 -delete
    echo "Success: logs archived to $ARCHIVE_PATH"
else
    echo "Error: archiving failed."
    exit 1
fi
