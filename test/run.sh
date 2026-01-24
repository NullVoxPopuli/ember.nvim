#!/bin/bash 
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)

nvim --clean -u "$SCRIPT_DIR/config.lua"
