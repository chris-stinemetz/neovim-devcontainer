# Neovim Development Environment (NvChad)

A Docker-based development environment with **Neovim + NvChad**, tmux, and Node.js for consistent coding across machines.

## Features

- 🚀 Neovim (latest stable)
- ✨ NvChad (starter config)
- 🖥️ tmux with plugin manager (TPM)
- 📦 Node.js 20.x with npm and yarn
- 💾 Persistent tmux sessions (tmux-resurrect)
- 🔧 Python 3 and build tools
- 📁 Access to all your projects

## Prerequisites

- Docker
- Docker Compose v2 (`docker compose`)
- Git

### WSL / Ubuntu note (Compose plugin)

If `docker compose` is missing on Ubuntu/WSL, install the plugin:

```sh
sudo apt-get update
sudo apt-get install -y docker-compose-plugin
docker compose version
```

## Quick Start

1. **Clone this repository:**

   ```sh
   git clone https://github.com/yourusername/nvim-dev.git
   cd nvim-dev
   ```

2. **Set up environment variables:**

   This repo runs the container as your user to avoid permission issues on mounted folders.
   Create a `.env` with your UID/GID:

   ```sh
   printf "UID=%s\nGID=%s\n" "$(id -u)" "$(id -g)" > .env
   ```

3. **Install a Nerd Font on your host (required for icons):**

   NvChad (and plugins like `nvim-tree`) use Nerd Font glyphs for icons.
   Install a Nerd Font on the **host OS** and set it as your terminal font.

   NvChad recommendation:
   - Prefer the family that **does not end with `Mono`** (icons tend to look smaller with `*Mono`).
   - Example: **FiraCode Nerd Font** (not **FiraCode Nerd Font Mono**)

   Windows Terminal: Settings → Profile → Appearance → Font face → choose your Nerd Font, then restart the terminal.

4. **Update the volume mount (optional):**
   Edit `docker-compose.yaml` to point to your projects directory:

   ```yaml
   volumes:
     - ~/src/Repos:/repos # Change this to your projects path
   ```

5. **Build and start the container:**

   ```sh
   docker compose up -d --build
   ```

6. **Attach to the tmux session:**
   ```sh
   docker compose exec dev tmux attach
   ```

## Usage

### Inside the Container

All your projects are mounted at `/repos`:

```sh
cd /repos/your-project
nvim .
```

### NvChad notes

- First launch may install plugins (give it a minute).
- If `nvim-tree` icons are missing, it’s almost always your **host terminal font** (see Troubleshooting).

### tmux Keybindings

- Prefix: `Ctrl+a` (instead of default `Ctrl+b`)
- Save session: `Ctrl+a` then `Ctrl+s`
- Restore session: `Ctrl+a` then `Ctrl+r`

### Managing the Container

```sh
# Stop the container
docker compose down

# Restart the container
docker compose restart

# View logs
docker compose logs -f

# Rebuild after changes
docker compose up -d --build
```

## Customization

### Add Neovim Config

Create your Neovim config and it will persist in the `nvim-config` volume:

```sh
docker compose exec dev nvim ~/.config/nvim/init.lua
```

### Modify tmux Config

Edit `.tmux.conf` and rebuild:

```sh
docker compose up -d --build
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

### Icons missing / wrong in NvChad (`nvim-tree`, statusline)

1. Install a Nerd Font on the **host OS**.
2. Configure your terminal to use it (choose the non-`Mono` family when available).
3. Restart the terminal and re-open Neovim.

Quick glyph test from WSL (icons should render if the host terminal font is correct):

```sh
printf "NerdFont test: \ue0b0  \ue0b1  \ue0a0  \uf115  \uf07b\n"
```

### Permission Issues

If you encounter permission issues with files created in the container:

1. Check your `.env` file has correct UID/GID
2. Rebuild: `docker compose up -d --build`

### tmux Session Exits

If tmux exits immediately:

```sh
docker compose logs dev
```

Check for permission errors and ensure `/home/developer` is owned by your UID:GID.

### Reset Neovim state (plugins/data)

This wipes persisted volumes (Neovim config/data/state/cache):

```sh
docker compose down -v
docker compose up -d --build
```

## License

MIT

## Contributing

PRs and issues are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## Security

See [SECURITY.md](SECURITY.md) for vulnerability reporting.
