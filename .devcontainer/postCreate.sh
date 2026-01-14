#!/bin/bash
set -e

echo "Updating submodules..."
git submodule update --init --recursive

echo "Setting up symlinks..."
./scripts/make-symlinks

echo "Configuring Opam environment..."
eval $(opam env)

echo "Installing Semgrep dependencies..."
# We use --no-depexts because we manually installed PCRE and libev via Dockerfile
# to work around Debian Trixie availability issues.
make install-deps-for-semgrep-core OPAM_FLAGS="--no-depexts"

echo "Installing Python dependencies for CLI..."
cd cli && pipenv install --dev

echo "Setup complete! You can now run 'make core' to build semgrep-core."
