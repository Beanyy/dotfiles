#!/usr/bin/env bash
set -euo pipefail
# set -x          # uncomment during debugging

echo "Starting dotfiles/setup script..."

# ─── Prerequisites ──────────────────────────────────────────────
command -v git >/dev/null 2>&1 || {
    echo "Error: git is not installed. Please install git first."
    exit 1
}

# ─── Helper function ────────────────────────────────────────────
install_if_missing() {
    local cmd="$1"
    local pkg="$2"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Installing $pkg..."
        sudo apt update -qq
        sudo apt install -y "$pkg"
    else
        echo "$pkg is already installed."
    fi
}

# ─── Vim + vim-plug + fzf ───────────────────────────────────────
echo "Setting up Vim..."

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || {
    echo "Failed to download vim-plug"
    exit 1
}

vim +'PlugInstall --sync' +qa || echo "PlugInstall had warnings/errors (non-fatal)"

# fzf
if [[ ! -d "$HOME/.fzf" ]]; then
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-update-rc --no-bash --no-fish
else
    echo "fzf already installed."
fi

# ─── Zsh + Oh My Zsh ────────────────────────────────────────────
install_if_missing zsh zsh

echo "Setting up Oh My Zsh..."
if [[ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]]; then
    ZSH= sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed."
fi

# ─── Zsh plugins & theme ────────────────────────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

declare -A plugins=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
)

for name in "${!plugins[@]}"; do
    dest="$ZSH_CUSTOM/plugins/$name"
    if [[ ! -d "$dest" ]]; then
        echo "Installing $name..."
        git clone --depth=1 "${plugins[$name]}" "$dest"
    else
        echo "$name already installed."
    fi
done

# Powerlevel10k (better to install via git than brew on Linux)
P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
    echo "Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "powerlevel10k already installed."
fi

# ─── Final steps ────────────────────────────────────────────────
echo ""
echo "Setup finished!"
echo ""
echo "Next steps:"
echo "  1. Edit ~/.zshrc and set these plugins:"
echo "       plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)"
echo "     and theme:"
echo "       ZSH_THEME=\"powerlevel10k/powerlevel10k\""
echo ""
echo "  2. Run once to configure powerlevel10k:"
echo "       p10k configure"
echo ""
echo "  3. Reload shell:   source ~/.zshrc    or open new terminal"
echo ""
echo "Done! Happy coding :)"
