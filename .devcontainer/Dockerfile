# Use Debian Trixie (Debian 13) as the base image for development
FROM mcr.microsoft.com/devcontainers/base:debian-13

# Install system dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    build-essential \
    pkg-config \
    m4 \
    unzip \
    curl \
    git \
    python3 \
    python3-pip \
    pipenv \
    python3-venv \
    libdw-dev \
    libunwind-dev \
    autoconf \
    libtool \
    wget \
    zlib1g-dev \
    libgmp-dev \
    patch \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js (needed for tree-sitter)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Build PCRE 8.45 from source (Debian Trixie only has PCRE2)
RUN wget https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz/download -O pcre-8.45.tar.gz \
    && tar -xzf pcre-8.45.tar.gz \
    && cd pcre-8.45 \
    && ./configure --prefix=/usr/local --enable-utf --enable-unicode-properties \
    && make -j$(nproc) \
    && make install \
    && cd .. \
    && rm -rf pcre-8.45 pcre-8.45.tar.gz

# Build libev 4.33 from source
RUN wget http://dist.schmorp.de/libev/libev-4.33.tar.gz \
    && tar -xzf libev-4.33.tar.gz \
    && cd libev-4.33 \
    && ./configure --prefix=/usr/local \
    && make -j$(nproc) \
    && make install \
    && cd .. \
    && rm -rf libev-4.33 libev-4.33.tar.gz

# Install Opam
RUN wget https://github.com/ocaml/opam/releases/download/2.3.0/opam-2.3.0-x86_64-linux -O /usr/local/bin/opam \
    && chmod +x /usr/local/bin/opam

# Switch to the vscode user for remaining setup
USER vscode
WORKDIR /home/vscode

# Initialize Opam and install OCaml 5.3.0 (semgrep's requirement)
RUN opam init --disabled-sandboxing --auto-setup --yes \
    && opam switch create 5.3.0 --yes \
    && eval $(opam env)

# Pre-install some common OCaml dependencies to speed up the first build
RUN eval $(opam env) && opam install -y \
    dune \
    ocamlfind \
    menhir \
    atdgen \
    yaml \
    pcre \
    lwt \
    ocaml-migrate-parsetree \
    ppx_deriving \
    && opam clean

# Set environment variables
ENV PATH="/home/vscode/.opam/5.3.0/bin:${PATH}"
ENV OCAML_TOPLEVEL_PATH="/home/vscode/.opam/5.3.0/lib/toplevel"

# Default command to bash
CMD ["/bin/bash"]
