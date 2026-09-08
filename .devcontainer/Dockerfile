# Use Debian Bookworm base image
FROM mcr.microsoft.com/devcontainers/python:1-3.12-bookworm

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Copy uv and uvx binaries directly from the official Astral image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

# Clean up any leftover legacy apt sources and install required packages
RUN rm -f /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get -y install --no-install-recommends \
        curl \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set default user
USER vscode