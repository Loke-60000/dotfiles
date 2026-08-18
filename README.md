
# Dotfiles Repository

This repository organizes `.bashrc` configurations and other environment-specific setup files for streamlined use across devices.

## Structure

- **bashrc/**: Contains modular `.bashrc` components:
  - `.bashrc`: Main entry that sources other configurations.
  - `.bash_aliases`: Stores command shortcuts.
  - `.bash_env`: Environment variables.
  - `.bash_functions`: Custom functions.

- **zshrc/**: `.zshrc` — zsh setup (powerlevel10k, plugins, Evangelion palette).

- **tmux/**: `.tmux.conf` — tmux setup, colors matched to ghostty/zsh.
  Session persistence needs two clones on a new machine:
  ```bash
  mkdir -p ~/.tmux/plugins && cd ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tmux-resurrect.git
  git clone https://github.com/tmux-plugins/tmux-continuum.git
  ```

- **laptop_configurations/**: Configurations for laptop setup.
  - **windows_Terminal/config.json**: Windows Terminal settings.
  - **arch-linux-setup-japanese-keyboard.sh**: Script for Japanese keyboard setup on Arch Linux.

- **server_configuration/nvidia/setup_GPU_fan.MD**: Guide for managing NVIDIA GPU fan settings on servers.

## Setup

```bash
git clone git@github.com:Loke-60000/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Installs packages (pacman or apt), clones the zsh and tmux plugins, and symlinks
every config back to this repo -- so editing `~/.zshrc` edits the repo. Anything
already in place is moved to `~/.dotfiles-backup/<timestamp>/` first. Safe to re-run.

Private things -- tokens, internal hosts, per-machine tweaks -- go in
`~/.zshrc.local`, which is created for you and never committed.

---
