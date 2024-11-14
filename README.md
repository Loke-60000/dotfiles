
# Dotfiles Repository

This repository organizes `.bashrc` configurations and other environment-specific setup files for streamlined use across devices.

## Structure

- **bashrc/**: Contains modular `.bashrc` components:
  - `.bashrc`: Main entry that sources other configurations.
  - `.bash_aliases`: Stores command shortcuts.
  - `.bash_env`: Environment variables.
  - `.bash_functions`: Custom functions.

- **laptop_configurations/**: Configurations for laptop setup.
  - **windows_Terminal/config.json**: Windows Terminal settings.
  - **arch-linux-setup-japanese-keyboard.sh**: Script for Japanese keyboard setup on Arch Linux.

- **server_configuration/nvidia/setup_GPU_fan.MD**: Guide for managing NVIDIA GPU fan settings on servers.

## Setup

1. **Clone** this repository.
   ```bash
   git clone git@github.com:Loke-60000/dotfiles.git ~/dotfiles
   ```

2. **Take what you need:** Copy the necessary configuration files to your home directory or appropriate locations. For example:
    ```bash
    cp ~/dotfiles/bashrc/.bashrc ~/.bashrc
    cp ~/dotfiles/bashrc/.bash_aliases ~/.bash_aliases
    cp ~/dotfiles/bashrc/.bash_env ~/.bash_env
    cp ~/dotfiles/bashrc/.bash_functions ~/.bash_functions
    ```

3. **Reload** `.bashrc` to apply changes:
   ```bash
   source ~/.bashrc
   ```

---
