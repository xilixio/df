# DFM - Dot Files Manager

A lightweight, cross-platform dotfiles manager for Linux and macOS. DFM helps you organize, version control, and deploy your configuration files across multiple machines.

## Features

- **Package-based organization**: Group related dotfiles into logical packages
- **Cross-platform support**: Define OS-specific install and check commands (Linux, macOS)
- **Architecture-aware**: Support for architecture-specific configurations (e.g., `Darwin/arm64`)
- **Dependency management**: Automatically install package dependencies in the correct order
- **Symlink management**: Track and link configuration files to their target locations
- **Git integration**: Built-in commands for syncing dotfiles across machines
- **Backup support**: Create backup branches before making changes

## Installation

### Quick Install

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xilixio/df/HEAD/scripts/install-dfm)"
```

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/xilixio/df.git ~/.dfm
   ```

2. Add to your shell configuration (`~/.bashrc` or `~/.zshrc`):
   ```bash
   export PATH="$PATH:$HOME/.dfm/bin"
   export DFM_DOTFILES="$HOME/.dotfiles"
   export DFM_YAML="$DFM_DOTFILES/packages.yaml"
   ```

3. Create your dotfiles directory:
   ```bash
   mkdir -p ~/.dotfiles
   cd ~/.dotfiles
   git init
   ```

4. Create a `packages.yaml` file (see [Configuration](#configuration) below)

### Prerequisites

- **bash** (4.0+ recommended)
- **git**
- **yq** (YAML processor) - automatically installed by the installer

## Configuration

DFM uses a `packages.yaml` file to define your packages. Each package can have OS-specific configurations.

### Basic Structure

```yaml
packages:
  package_name:
    Linux:
      install: "command to install"
      check: "command to verify installation"
      deps:
        - dependency1
        - dependency2
    Darwin:
      install: "macOS install command"
      check: "macOS check command"
```

### Example Configuration

```yaml
packages:
  # Simple package with Homebrew
  ripgrep:
    Darwin:
      install: "brew install ripgrep"
      check: "command -v rg"
    Linux:
      install: "sudo apt-get install -y ripgrep"
      check: "command -v rg"

  # Package with dependencies
  neovim_config:
    Darwin:
      deps:
        - neovim
      install: "dfm link neovim_config init.lua ~/.config/nvim/init.lua"
      check: "[ -L ~/.config/nvim/init.lua ]"
    Linux:
      deps:
        - neovim
      install: "dfm link neovim_config init.lua ~/.config/nvim/init.lua"
      check: "[ -L ~/.config/nvim/init.lua ]"

  neovim:
    Darwin:
      install: "brew install neovim"
      check: "command -v nvim"
    Linux:
      install: "sudo apt-get install -y neovim"
      check: "command -v nvim"

  # Architecture-specific configuration
  docker:
    Darwin/arm64:
      install: "brew install --cask docker"
      check: "command -v docker"
    Darwin/x86_64:
      install: "brew install --cask docker"
      check: "command -v docker"
    Linux:
      install: "curl -fsSL https://get.docker.com | sh"
      check: "command -v docker"
```

### Package Fields

| Field | Required | Description |
|-------|----------|-------------|
| `install` | Yes | Shell command to install the package |
| `check` | Yes | Shell command that returns 0 if package is installed |
| `deps` | No | List of package names that must be installed first |

### Package Naming Rules

Package names must contain only:
- Letters (a-z, A-Z)
- Numbers (0-9)
- Underscores (_)

## Commands

### Package Management

| Command | Description |
|---------|-------------|
| `dfm list` | List all defined packages |
| `dfm check <package>` | Check if a package is installed |
| `dfm install [packages...]` | Install packages (all if none specified) |
| `dfm deps <package>` | List dependencies for a package |
| `dfm new <package> [-d] [-df]` | Create a new package entry |

### File Management

| Command | Description |
|---------|-------------|
| `dfm track <package> <paths...>` | Move files to package directory and create symlinks |
| `dfm link <package> <source> <target>` | Create symlink from package file to target location |
| `dfm islinked <package> <target>` | Check if target is linked to package |

### Git Operations

| Command | Description |
|---------|-------------|
| `dfm status` | Show git status of dotfiles repository |
| `dfm diff` | Show git diff of dotfiles repository |
| `dfm pull` | Pull changes from remote (with rebase and autostash) |
| `dfm push` | Commit and push all changes to remote |
| `dfm sync` | Pull then push (combines pull and push) |
| `dfm backup` | Create a backup branch with current changes |

### Utilities

| Command | Description |
|---------|-------------|
| `dfm edit` | Open packages.yaml in your editor |
| `dfm update` | Update DFM itself |

## Usage Examples

### Setting Up a New Machine

```bash
# 1. Install DFM
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xilixio/df/HEAD/scripts/install-dfm)"

# 2. Reload shell
source ~/.bashrc  # or ~/.zshrc

# 3. Clone your dotfiles
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles

# 4. Install all packages
dfm install -y
```

### Creating a New Package

```bash
# Create package entry with directory and starter script
dfm new my_shell_config -df

# Track your existing config files
dfm track my_shell_config ~/.bashrc ~/.bash_aliases

# The files are now in ~/.dotfiles/packages/my_shell_config/
# and symlinked back to their original locations
```

### Installing Specific Packages

```bash
# Install a single package
dfm install neovim

# Install multiple packages
dfm install ripgrep fzf neovim

# Install with automatic yes to prompts
dfm install -y neovim

# Install silently
dfm install -s -y neovim

# Install ignoring failures
dfm install -i neovim
```

### Syncing Across Machines

```bash
# Pull latest changes
dfm pull

# Make changes to your configs, then push
dfm push

# Or do both at once
dfm sync
```

## Directory Structure

```
~/.dotfiles/
├── packages.yaml          # Package definitions
└── packages/
    ├── neovim_config/
    │   └── init.lua       # Linked to ~/.config/nvim/init.lua
    ├── git_config/
    │   └── .gitconfig     # Linked to ~/.gitconfig
    └── shell_config/
        ├── .bashrc        # Linked to ~/.bashrc
        └── .bash_aliases  # Linked to ~/.bash_aliases
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DFM_DOTFILES` | `~/.dotfiles` | Path to your dotfiles repository |
| `DFM_YAML` | `$DFM_DOTFILES/packages.yaml` | Path to packages.yaml |
| `EDITOR` | vim/vi/nano | Editor used by `dfm edit` |

## Testing

Run the test suite:

```bash
make test
```

## Troubleshooting

### "Package name invalid" error

Package names can only contain letters, numbers, and underscores. Rename packages that contain hyphens or special characters.

### "DFM_YAML file doesn't exist" error

Create a `packages.yaml` file in your dotfiles directory:

```bash
echo "packages:" > ~/.dotfiles/packages.yaml
```

### "yq is not installed" error

Run the installer script or install yq manually:

```bash
# macOS
brew install yq

# Linux (Debian/Ubuntu)
sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
sudo chmod +x /usr/local/bin/yq
```

### Symlink creation failed

Ensure the target directory exists and you have write permissions. DFM will automatically create parent directories, but may fail if permissions are insufficient.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `make test` to ensure tests pass
5. Submit a pull request

## License

MIT License - see LICENSE file for details.
