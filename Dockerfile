# Start from a lightweight Ubuntu base
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install ca-certificates package first
RUN apt-get update && apt-get install -y ca-certificates openssl && \
    rm -rf /var/lib/apt/lists/*

# Copy certificates (optional): directory always exists in repo (may be empty)
COPY config/certs/ /usr/local/share/ca-certificates/

# Update certificates if any were copied
RUN if [ -n "$(ls -A /usr/local/share/ca-certificates/*.crt 2>/dev/null)" ]; then \
        echo "=== Certificate debugging ===" && \
        for cert in /usr/local/share/ca-certificates/*.crt; do \
            echo "Checking $cert:"; \
            openssl x509 -in "$cert" -subject -issuer -noout 2>/dev/null || echo "Invalid cert"; \
            echo "---"; \
        done && \
        chmod 644 /usr/local/share/ca-certificates/*.crt && \
        update-ca-certificates && \
        cat /etc/ssl/certs/ca-certificates.crt > /etc/ssl/certs/node-bundle.pem && \
        echo "Custom certificates installed"; \
    else \
        echo "No custom certificates found, using system defaults"; \
    fi

# Set certificate environment variables
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt \
    CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt \
    NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt \
    GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt

# Update system and install dependencies
RUN apt-get update && apt-get install -y \
  curl wget git build-essential software-properties-common \
  python3 python3-pip \
  tmux \
  && rm -rf /var/lib/apt/lists/*

# Install Neovim (unstable) and kickstart dependencies
RUN apt-get update && apt-get install -y software-properties-common \
  && add-apt-repository ppa:neovim-ppa/unstable -y \
  && apt-get update && apt-get install -y \
  make gcc ripgrep unzip git xclip neovim \
  && rm -rf /var/lib/apt/lists/*

# --- Install latest Node.js (using NodeSource) ---
RUN apt-get remove -y libnode-dev nodejs-doc || true
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y nodejs

# Optional: install yarn
RUN npm install -g yarn

# --- Install tmux plugin manager (TPM) ---
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Copy tmux config (with tmux-resurrect + continuum)
COPY .tmux.conf /root/.tmux.conf

# Create dev user with bash shell
RUN useradd -m -s /bin/bash -u 1000 dev && \
  cp /root/.tmux.conf /home/dev/.tmux.conf && \
  git clone https://github.com/tmux-plugins/tpm /home/dev/.tmux/plugins/tpm && \
  chown -R dev:dev /home/dev

# Clone Neovim kickstart configuration for dev user
RUN mkdir -p /home/dev/.config && \
  git clone https://github.com/NvChad/starter.git /home/dev/.config/nvim && \
  chown -R dev:dev /home/dev/.config

# Create Neovim data directories with proper permissions
RUN mkdir -p /home/dev/.local/share/nvim /home/dev/.local/state/nvim /home/dev/.cache/nvim && \
  chown -R dev:dev /home/dev/.local /home/dev/.cache

WORKDIR /repos

# Default command: start tmux (so Neovim can run inside it)
CMD ["tmux"]
