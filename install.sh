#!/usr/bin/env bash
# zsh + tmux + ghostty. safe to re-run.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
skipped=()

say() { printf '\n\033[38;5;214m==>\033[0m %s\n' "$1"; }

cat <<'BANNER'

ヽ(*ﾟдﾟ)ノ  STOP!

   "This is Loke's setup. If you are not Loke, this does what I want on my
    machines, not what you want on yours. Run it and whatever happens next
    is yours to deal with. Read the script first. It is under a hundred
    lines. You have the time."

   "Arch with pacman, or Debian and Ubuntu with apt. On anything else I skip
    the packages and keep going. Nothing else has been tested."

   "Here is what I touch:"

     installs   zsh tmux git fzf zoxide eza bat fd, the Hack font, wl-clipboard
     clones     powerlevel10k, 5 zsh plugins, tmux-resurrect, tmux-continuum
     symlinks   .zshrc  .p10k.zsh  .tmux.conf  the clean-ibm zsh theme, and
                ghostty's config, themes, shaders and images
     also       makes zsh your login shell, writes ~/.zshrc.local for private
                things you do not want in git

   "Anything already sitting in those paths moves to ~/.dotfiles-backup.
    I delete nothing."

BANNER

cat <<'AGREE'
   I agree that Loke's script will either install the same setup as his, or
   destroy my linux install, and/or turn my PC into a thermonuclear device
   that causes the destruction of my current location.

AGREE
answer=""
read -r -p "   yes = I read it and understand. anything else = let me read it first: " answer || true
if [ "$answer" != yes ]; then
    echo
    echo "   Good. Go read it."
    exit 0
fi

# symlink into the repo, backing up whatever is there
link() {
    local src="$REPO/$1" dst="$HOME/$2"
    [ -e "$src" ] || { skipped+=("$1 (missing in repo)"); return; }
    [ "$(readlink -f "$dst" 2>/dev/null)" = "$(readlink -f "$src")" ] && return
    mkdir -p "$(dirname "$dst")"
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mkdir -p "$BACKUP/$(dirname "$2")"
        mv "$dst" "$BACKUP/$2"
    fi
    ln -sfn "$src" "$dst"
}

# clone once, leave existing checkouts alone
clone() {
    local url="$1" dir="$2"
    [ -d "$dir/.git" ] && return
    mkdir -p "$(dirname "$dir")"
    git clone -q --depth 1 "$url" "$dir"
}

say "Installing packages"
PKGS=(zsh tmux git fzf zoxide eza bat fd)
if command -v pacman >/dev/null; then
    sudo pacman -S --needed --noconfirm "${PKGS[@]}" ttf-hack wl-clipboard
elif command -v apt-get >/dev/null; then
    # different names on debian/ubuntu
    sudo apt-get update -qq
    sudo apt-get install -y "${PKGS[@]/fd/fd-find}" fonts-hack wl-clipboard
else
    skipped+=("packages (no pacman or apt-get -- install ${PKGS[*]} yourself)")
fi

say "Fetching zsh plugins"
clone https://github.com/romkatv/powerlevel10k.git            "$HOME/.zsh/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions        "$HOME/.zsh/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting    "$HOME/.zsh/plugins/zsh-syntax-highlighting"
clone https://github.com/zsh-users/zsh-completions            "$HOME/.zsh/plugins/zsh-completions"
clone https://github.com/zsh-users/zsh-history-substring-search "$HOME/.zsh/plugins/zsh-history-substring-search"
clone https://github.com/Aloxaf/fzf-tab                       "$HOME/.zsh/plugins/fzf-tab"

say "Fetching tmux plugins"
clone https://github.com/tmux-plugins/tmux-resurrect.git  "$HOME/.tmux/plugins/tmux-resurrect"
clone https://github.com/tmux-plugins/tmux-continuum.git  "$HOME/.tmux/plugins/tmux-continuum"

say "Linking configs"
link zshrc/.zshrc              .zshrc
link zshrc/.p10k.zsh           .p10k.zsh
link zshrc/themes/clean-ibm.zsh .zsh/themes/clean-ibm.zsh
link tmux/.tmux.conf           .tmux.conf
link ghostty/config            .config/ghostty/config
link ghostty/themes            .config/ghostty/themes
link ghostty/shaders           .config/ghostty/shaders
link ghostty/images            .config/ghostty/images

# private stuff, outside the repo
[ -f "$HOME/.zshrc.local" ] || cat > "$HOME/.zshrc.local" <<'LOCAL'
# Not tracked by git. Put tokens, private hosts and per-machine tweaks here.
LOCAL

if [ "${SHELL##*/}" != zsh ] && command -v zsh >/dev/null; then
    say "Making zsh your login shell"
    chsh -s "$(command -v zsh)" || skipped+=("chsh (run it yourself: chsh -s $(command -v zsh))")
fi

say "Done"
[ -d "$BACKUP" ] && echo "    replaced files saved in $BACKUP"
for s in ${skipped+"${skipped[@]}"}; do echo "    skipped: $s"; done
echo "    open a new terminal to start"
