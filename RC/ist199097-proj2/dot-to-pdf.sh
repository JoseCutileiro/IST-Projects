#!/bin/bash

set -euo pipefail

# Usage: dot-to-pdf.sh <input.dot> [output.pdf]
INPUT_DOT="${1}"
OUTPUT_PDF="${2:-"$(basename "$INPUT_DOT" ".dot").pdf"}"

TEMP_DIR="$(mktemp -d)"

function cleanup {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT


# Split DOT file into separate graphs.
csplit --quiet --elide-empty-files --prefix="$TEMP_DIR/page" --suffix-format="%08d.dot" "$INPUT_DOT" "/^$/" "{*}"

# Convert each graph into PDF.
parallel 'circo -Tpdf -O {}' ::: $TEMP_DIR/page*.dot


# Concatenate the pages to form final PDF.
pdftk $TEMP_DIR/page*.pdf cat output "$OUTPUT_PDF"

