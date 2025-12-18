# Contributing

Thanks for helping improve this repo.

## What this repo is

This project provides a Docker-based development environment for running **Neovim with NvChad** inside a container (typically via WSL), with tmux and common dependencies.

## Before you start

- Keep PRs focused (one change or one theme per PR).
- Prefer small, reviewable commits.
- Avoid committing large runtime state or caches.

### Fonts policy (important)

- Nerd Fonts must be installed on the **host OS** (e.g., Windows Terminal), not inside the container.
- Do **not** commit font binaries to this repo.

## Development setup

### Prerequisites

- Docker Engine / Docker Desktop
- Docker Compose v2 (`docker compose`)

On Ubuntu/WSL, install the Compose plugin if needed:

```sh
sudo apt-get update
sudo apt-get install -y docker-compose-plugin
```

### Configure UID/GID

Create a local `.env` (do not commit it):

```sh
printf "UID=%s\nGID=%s\n" "$(id -u)" "$(id -g)" > .env
```

### Build and run

```sh
docker compose up -d --build
```

Attach to tmux:

```sh
docker compose exec dev tmux attach
```

## Testing changes

For most changes, the following smoke tests are sufficient:

```sh
# rebuild image
docker compose build

# start container
docker compose up -d

# confirm nvim launches
docker compose exec dev bash -lc 'nvim --version | head -n 5'
```

If your change affects docs, confirm the README commands still work.

## Reporting bugs

Please open an issue with:

- Host OS (Windows/macOS/Linux)
- WSL distro (if applicable)
- Terminal app (Windows Terminal / VS Code / WezTerm, etc.)
- Output of:
  - `docker version`
  - `docker compose version`
- What you expected vs what happened
- Logs (if applicable): `docker compose logs -f --tail=200`

## Pull requests

- Use clear titles (examples: `docs: ...`, `build: ...`, `fix: ...`).
- Mention the motivation (what it fixes/improves).
- Include test commands you ran.

## Code of Conduct

This project follows the guidelines in `CODE_OF_CONDUCT.md`.
