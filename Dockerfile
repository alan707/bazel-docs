# Dockerfile with version variables and architecture-aware Hugo Extended installation

# Base Python image (overrideable)
ARG PYTHON_IMAGE=python:3.12-slim-bookworm
FROM ${PYTHON_IMAGE}

# Version arguments for easy updates
ARG HUGO_VERSION=0.146.0
ARG NODE_MAJOR_VERSION=22

# Install system dependencies, Go, Git, Hugo Extended (arch-aware), Node.js, PostCSS, and uv
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    golang-go \
    # Determine architecture and download matching Hugo Extended binary
    && ARCH="$(dpkg --print-architecture)" \
    && case "${ARCH}" in \
    amd64) HUGO_ARCH="Linux-64bit" ;; \
    arm64) HUGO_ARCH="Linux-ARM64" ;; \
    *) echo "Unsupported arch: ${ARCH}" >&2; exit 1 ;; \
    esac \
    && curl -sSL \
    "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_${HUGO_ARCH}.tar.gz" \
    | tar xz -C /usr/local/bin hugo \
    # Install Node.js LTS and PostCSS tools
    && curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g autoprefixer postcss-cli postcss \
    # Install uv
    && curl -LsSf https://astral.sh/uv/install.sh | sh \
    # Cleanup
    && rm -rf /var/lib/apt/lists/*

# Ensure uv/uvx are on PATH and disable Python output buffering
ENV PATH="/root/.local/bin:$PATH" \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copy project metadata
COPY pyproject.toml ./

# Copy the Hugo site from docs directory
COPY docs/ ./app/
COPY public/ ./app/public/

# # Add venv binaries to PATH
ENV PATH="/app/.venv/bin:$PATH"

# Sync dependencies into virtual environment
RUN uv sync

EXPOSE 1313

CMD ["hugo", "server", "-s", "/app/docs/", "--bind", "0.0.0.0"]
