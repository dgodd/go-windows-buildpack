#!/usr/bin/env bash
set -exuo pipefail

cd "$( dirname "${BASH_SOURCE[0]}" )/.."

GOOS=linux go build -ldflags="-s -w" -o bin/supply ./supply
GOOS=linux go build -ldflags="-s -w" -o bin/finalize ./finalize
