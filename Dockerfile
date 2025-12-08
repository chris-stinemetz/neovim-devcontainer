# Start from a lightweight Ubuntu base
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Update system and install dependencies
RUN apt-get update && apt-get install -y \
  curl wget git build-essential software-properties-common \
  python3 python3-pip \
  tmux \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y software-properties-common \
  && add-apt-repository ppa:neovim-ppa/stable \
  && apt-get update && apt-get install -y neovim

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

# Create developer user home directory with proper permissions
RUN mkdir -p /home/developer && \
  cp /root/.tmux.conf /home/developer/.tmux.conf && \
  git clone https://github.com/tmux-plugins/tpm /home/developer/.tmux/plugins/tpm && \
  chown -R 1000:1000 /home/developer

WORKDIR /repos

# Default command: start tmux (so Neovim can run inside it)
CMD ["tmux"]