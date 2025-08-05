#!/bin/bash

ORIGINAL_DIR="$(pwd)"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RELATIVE_PATH="$SCRIPT_DIR/../config.json"

python3 "$SCRIPT_DIR/config_manager.py" --config="$RELATIVE_PATH" --mode=update

cd "$ORIGINAL_DIR"
