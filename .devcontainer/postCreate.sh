#!/bin/bash
set -e

echo "Updating submodules..."
git submodule update --init --recursive

echo "Setting up symlinks..."
./scripts/make-symlinks

echo "Configuring Opam environment..."
eval $(opam env)

echo "Configuring GitHub access..."
if [ -n "$GITHUB_TOKEN" ]; then
    echo "Logging into GitHub CLI..."
    echo "$GITHUB_TOKEN" | gh auth login --with-token
    # Ensure git uses the token for these specific remotes if they exist
    echo "Updating remote URLs..."
    git remote set-url origin https://rangoel-nu:$GITHUB_TOKEN@github.com/NuGuardAI/semgrep.git || true
fi

echo "Installing Semgrep dependencies..."
# We use --no-depexts because we manually installed PCRE and libev via Dockerfile
# to work around Debian Trixie availability issues.
make install-deps-for-semgrep-core OPAM_FLAGS="--no-depexts"

echo "Installing Python dependencies for CLI..."
cd cli && pipenv install --dev

echo "Setup complete! You can now run 'make core' to build semgrep-core."
