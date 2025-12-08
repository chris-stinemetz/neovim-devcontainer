# Neovim Development Environment

A Docker-based development environment with Neovim, tmux, and Node.js for consistent coding across machines.

## Features

- 🚀 Neovim (latest stable)
- 🖥️ tmux with plugin manager (TPM)
- 📦 Node.js 20.x with npm and yarn
- 💾 Persistent tmux sessions (tmux-resurrect)
- 🔧 Python 3 and build tools
- 📁 Access to all your projects

## Prerequisites

- Docker
- Docker Compose
- Git

## Quick Start

1. **Clone this repository:**

   ```sh
   git clone https://github.com/yourusername/nvim-dev.git
   cd nvim-dev
   ```

2. **Set up environment variables:**

   ```sh
   cp .env.example .env
   ```

   Or auto-populate with your UID/GID:

   ```sh
   echo "UID=$(id -u)" > .env
   echo "GID=$(id -g)" >> .env
   ```

3. **Update the volume mount (optional):**
   Edit `docker-compose.yaml` to point to your projects directory:

   ```yaml
   volumes:
     - ~/src/Repos:/repos # Change this to your projects path
   ```

4. **Build and start the container:**

   ```sh
   docker-compose up -d --build
   ```

5. **Attach to the tmux session:**
   ```sh
   docker-compose exec dev tmux attach
   ```

## Usage

### Inside the Container

All your projects are mounted at `/repos`:

```sh
cd /repos/your-project
nvim .
```

### tmux Keybindings

- Prefix: `Ctrl+a` (instead of default `Ctrl+b`)
- Save session: `Ctrl+a` then `Ctrl+s`
- Restore session: `Ctrl+a` then `Ctrl+r`

### Managing the Container

```sh
# Stop the container
docker-compose down

# Restart the container
docker-compose restart

# View logs
docker-compose logs -f

# Rebuild after changes
docker-compose up -d --build
```

## Customization

### Add Neovim Config

Create your Neovim config and it will persist in the `nvim-config` volume:

```sh
docker-compose exec dev nvim ~/.config/nvim/init.lua
```

### Modify tmux Config

Edit `.tmux.conf` and rebuild:

```sh
docker-compose up -d --build
```

### Install Additional Tools

Add packages to `Dockerfile` and rebuild:

```dockerfile
RUN apt-get update && apt-get install -y your-package
```

## Persistent Data

The following are stored in Docker volumes and persist across container restarts:

- Neovim configuration (`~/.config/nvim`)
- Neovim plugins and data (`~/.local/share/nvim`)
- tmux sessions (`~/.tmux`)

## Troubleshooting

### Permission Issues

If you encounter permission issues with files created in the container:

1. Check your `.env` file has correct UID/GID
2. Rebuild: `docker-compose up -d --build`

### tmux Session Exits

If tmux exits immediately:

```sh
docker-compose logs dev
```

Check for permission errors and ensure `/home/developer` is owned by your UID:GID.

## License

MIT
