#!/usr/bin/env bash
set -euo pipefail

source _build_dependencies.sh

wget -nv -O librust_g.so "https://github.com/tgstation/rust-g/releases/download/$RUST_G_VERSION/librust_g.so"
chmod +x librust_g.so
ldd librust_g.so
