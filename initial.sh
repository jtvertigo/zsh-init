#!/bin/bash

set -eo pipefail

# Check for /etc/os-release file
if [ -f /etc/os-release ]; then
  source /etc/os-release
  if [ -n "$ID" ]; then
    echo "Linux distribution: $ID"
  else
    echo "Uknown \$ID variable"
    exit 9
  fi
else
  echo "Unable to determine Linux distribution."
  exit 9
fi

#OS="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
NVIM_VERSION="v0.9.5"

case $ID in
  ubuntu)
    pmng="apt"
    ;;
  debian)
    pmng="apt"
    ;;
  *)
    echo "Unsupported Linux distribution"
    exit 9
    ;;
esac

#if [[ "$ID" == "CentOS"* ]]; then
#  echo -e "\n==> Linux distribution is: $OS"
#  pmng="yum"
#  bash=".bash_profile"
#elif [[ "$ID" == *"Red Hat"* ]]; then
#  echo -e "\n==> Linux distribution is: $OS"
#  pmng="yum"
#  bash=".bash_profile"
#elif [[ "$ID" == *"Rocky"* ]]; then
#  echo -e "\n==> Linux distribution is: $OS"
#  pmng="dnf"
#  bash=".bash_profile"
#elif [[ "$ID" == *"ubuntu"* ]]; then
#  echo -e "\n==> Linux distribution is: $OS"
#  pmng="apt"
#  bash=".bashrc" # FIXME
#elif [[ "$ID" == "Debian"* ]]; then
#  echo -e "\n==> Linux distribution is: $OS"
#  pmng="apt"
#  bash=".bashrc" # FIXME
#else
#  echo -e "\n==> Unknown Linux distribution"; exit;
#fi

echo -e "\n==> Installing wget git tree curl less vim"
sudo $pmng update
sudo $pmng install -y \
  wget \
  git \
  tree \
  jq \
  curl \
  less \
  vim \
  tmux \
  build-essential \
  unzip \
  python3-venv

# if [[ -f "${HOME}"/.gitconfig ]] ; then
  # echo -e "\n==> File ${HOME}/.gitconfig exists!"
# else
echo -e "\n==> Setting git config parameters"
cp .gitconfig "${HOME}/.gitconfig"
  # git config --global user.name "vertigojt"
  # git config --global user.email "vertigojt@null.domain"
# fi

echo -e "\n==> Setting colorscheme for vim"
mkdir -p ~/.vim/colors
git clone https://github.com/Rigellute/rigel.git
git clone https://github.com/catppuccin/vim.git
cp rigel/colors/rigel.vim ~/.vim/colors
cp vim/colors/catppuccin_*.vim ~/.vim/colors

echo -e "\n==> Installing plugin manager for vim"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo -e "\n==> Setting up .vimrc file"
cat > ~/.vimrc << EOF
set termguicolors
syntax enable
colorscheme catppuccin_mocha
set autoindent expandtab tabstop=2 shiftwidth=2
hi Normal guibg=NONE ctermbg=NONE

call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
call plug#end()

let g:airline_powerline_fonts = 1
let g:airline_theme = 'catppuccin_mocha'
EOF

echo -e "\n==> Installing zsh"
sudo $pmng -y install zsh

echo -e "\n==> Installing oh-my-zsh"
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sed -i 's/exec zsh -l/ /' install.sh
chmod +x ./install.sh
./install.sh

echo -e "\n==> Installing oh-my-zsh plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

echo -e "\n==> Enabling plugins in ${HOME}/.zshrc"
sed -i 's/^plugins=(git.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting kube-ps1)/' ~/.zshrc

echo -e "\n==> Copying theme to oh-my-zsh folder"
cp vertigo.zsh-theme ~/.oh-my-zsh/themes/

echo -e "\n==> Enabling vertigo theme as default"
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="vertigo"/' ~/.zshrc


# bat installation
if ! bat --help > /dev/null ; then
  echo -e "\n==> Installing bat ..."
  # TODO: get bat version from variable
  curl -sSL "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz" | tar -xzf - -C /tmp && sudo cp /tmp/bat-v*/bat /usr/local/bin/ 
fi
echo -e "\n==> Setting theme for bat"
rm -rf "$(bat --config-dir)"
mkdir -p "$(bat --config-dir)/themes"
cp -r .config/bat/themes/* "$(bat --config-dir)/themes"
# curl --output-dir "$(batcat --config-dir)/themes" -LO https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
# curl --output-dir "$(batcat --config-dir)/themes" -LO https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
# curl --output-dir "$(batcat --config-dir)/themes" -LO https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
# curl --output-dir "$(batcat --config-dir)/themes" -LO https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build
echo 'export BAT_THEME="catppuccin-mocha"' >> ~/.zshrc

# delta installation
if ! delta --help > /dev/null ; then
  echo -e "\n==> Installing delta ..."
  # TODO: get delta version from variable
  curl -sSL "https://github.com/dandavison/delta/releases/download/0.17.0/delta-0.17.0-x86_64-unknown-linux-gnu.tar.gz" | tar -xzf - -C /tmp && sudo cp /tmp/delta-*/delta /usr/local/bin/
fi

sleep 5

echo -e "\n==> Adding aliases && highlight envs to ${HOME}/.zshrc file"
echo '
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

alias k="kubectl"
alias kgp="kubectl get pods"
alias kgpa="kubectl get pods -A"
alias kgd="kubectl get deployment"
alias kgda="kubectl get deployment -A"
alias kgss="kubectl get statefulset"
alias kgssa="kubectl get statefulset -A"
alias kgs="kubectl get services"
alias kgsa="kubectl get services -A"
alias kga="kubectl get all"
alias kgaa="kubectl get all -A"
alias kgaaw="kubectl get all -A -o wide"
alias kgn="kubectl get nodes"
alias kgnw="kubectl get nodes -o wide"
alias kgns="kubectl get ns"

alias kdp="kubectl describe pod"
alias kdd="kubectl describe deployment"
alias kds="kubectl describe service"

alias d="docker"
alias dp="docker ps"
alias dpa="docker ps -a"
alias di="docker images"
alias dc="docker compose"

alias t="tkn"

alias sss="ss -tulpna | grep -i listen"
alias ssss="sudo ss -tulpna | grep -i listen"

alias tf="terraform"
alias tfp="terraform plan"
alias tfaa="terraform apply -auto-approve"

alias gi="git init ."
alias gl="git log"
alias glb="git log | bat"
alias ga="git add -A"
alias gs="git status"
alias gc="git commit -m "
alias gd="git diff"
alias gdb="git diff | bat"
alias gpom="git push origin master"

alias au="sudo apt update"
alias aup="sudo apt update -y"
alias status="systemctl status "

alias vim="nvim"
alias vi="/usr/bin/vim"

alias t="tmux"
alias ta="tmux attach"

alias p="pulumi"

alias zshup="rm -rf ~/.oh-my-zsh && git clone https://github.com/jtvertigo/zsh-init && cd zsh-init && ./initial.sh"

if nvim --version &> /dev/null; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

export VISUAL=$EDITOR
export SYSTEMD_EDITOR=$EDITOR' >> ~/.zshrc

sleep 2

echo '
alias cat="bat"
alias ccat="/usr/bin/cat"

# History
HISTSIZE=6000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt inc_append_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
' >> ~/.zshrc

sleep 1

#if [[ "$OS" == *"Rocky"* ]]; then
#  echo -e "\n==> Making zsh as default shell"
#  sudo usermod -s $(which zsh) ${USER}
#fi

if kubectl &> /dev/null; then
  echo -e "\n==> Adding autocompletion for kubectl"
  echo '[[ $commands[kubectl] ]] && source <(kubectl completion zsh)' >> ~/.zshrc
fi

sleep 1

if tkn &> /dev/null; then
  echo -e "\n==> Adding autocompletion for tekton"
  echo '[[ $commands[tkn] ]] && source <(tkn completion zsh)' >> ~/.zshrc
fi

sleep 1

if helm &> /dev/null; then
  echo -e "\n==> Adding autocomletion for helm"
  # helm completion zsh > "${fpath[1]}/_helm"
  echo '[[ $commands[helm] ]] && source <(helm completion zsh)' >> ~/.zshrc
fi

if pulumi &> /dev/null; then
  echo -e "\n==> Adding pulumi binary in \$PATH"
  if cat ~/.zshrc | grep pulumi/bin ; then
    echo -e "\n==> pulumi binary already in \$PATH"
  else
    echo "export PATH=\"\$PATH:\${HOME}/.pulumi/bin\"" >> ~/.zshrc
  fi
 
  echo -e "\n==> Adding autocompletion for pulumi"
  echo '[[ $commands[pulumi] ]] && source <(pulumi completion zsh)' >> ~/.zshrc

  #if [[ ":$PATH:" != *"pulumi/bin"* ]]; then
  #  echo "export PATH=\"\$PATH:\${HOME}/.pulumi/bin\"" >> ~/.zshrc
  #fi

fi

if go version &> /dev/null; then
  echo -e "\n==> Adding go binary in \$PATH"
  if cat ~/.zshrc | grep usr/local/go/bin ; then
    echo -e "\n==> go binary already in \$PATH"
  else
    echo "export PATH=\"\$PATH:/usr/local/go/bin\"" >> ~/.zshrc
  fi

  #if [[ ":$PATH:" != *"usr/local/go/bin"* ]]; then
  #  echo "export PATH=\"\$PATH:/usr/local/go/bin\"" >> ~/.zshrc
  #fi
fi

sleep 1

echo '
if kubectl &> /dev/null; then
  kubeon
else
  kubeoff
fi

if [ -e $HOME/.kube/config ]; then
  export KUBECONFIG=$HOME/.kube/config
fi' >> ~/.zshrc

sleep 1

vim +PlugInstall +qall

echo -e "\n==> Setting theme for airline (vim)"
cp vim/autoload/airline/themes/catppuccin_*.vim ~/.vim/plugged/vim-airline-themes/autoload/airline/themes

echo -e "\n==> Installing plugin manager for tmux"
rm -rf "${HOME}"/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo -e "\n==> Copy settings file for tmux"
rm -rf "${HOME}"/.tmux.conf
rm -rf "${HOME}"/.config/tmux/
mkdir -p "${HOME}"/.config/tmux
cp .config/tmux/tmux.conf "${HOME}"/.config/tmux/tmux.conf

if nvim --version &> /dev/null; then
  echo -e "\n==> nvim already installed!"
else
  echo -e "\n==> Installing nvim" 
  curl -LO https://github.com/neovim/neovim/releases/download/"${NVIM_VERSION}"/nvim-linux64.tar.gz
  sudo rm -rf ~/.nvim
  mkdir -p ~/.nvim
  sudo tar -C ~/.nvim -xzf nvim-linux64.tar.gz
fi

sleep 5

echo -e "\n==> Adding nvim binary in \$PATH"
if cat ~/.zshrc | grep nvim/nvim ; then
  echo -e "\n==> nvim binary already in \$PATH"
else
  echo "export PATH=\"\$PATH:\${HOME}/.nvim/nvim-linux64/bin\"" >> ~/.zshrc
fi
  
export PATH="$PATH:${HOME}/.nvim/nvim-linux64/bin"

#sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
#  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo -e "\n==> Setting up nvim with lua config"
rm -rf "${HOME}"/.config/nvim
sudo rm -rf "${HOME}"/.local/share/nvim
mkdir -p "${HOME}"/.config/nvim
cp -r .config/nvim/* "${HOME}"/.config/nvim/

echo -e "\n==> Install tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins
sleep 5

if test -d "${HOME}/.config/tmux/plugins/tokyo-night-tmux"; then
  echo -e "\n==> Setting up tmux tokyo-night plugin"
  sed -i 's@^tmux set -g window-status-current-format.*$@tmux set -g window-status-current-format "$RESET#[fg=${THEME[green]},bg=${THEME[bblack]}] #{?#{==:#{pane_current_command},ssh},󰣀, } #[fg=${THEME[foreground]},bold,nodim]$window_number #{b:pane_current_path}#[nobold]#{?window_zoomed_flag, $zoom_number, $custom_pane} #{?window_last_flag,,} "@' "${HOME}/.config/tmux/plugins/tokyo-night-tmux/tokyo-night.tmux"

  sed -i 's@^tmux set -g window-status-format.*$@tmux set -g window-status-format "$RESET#[fg=${THEME[foreground]}] #{?#{==:#{pane_current_command},ssh},󰣀,}${RESET} $window_number #{b:pane_current_path}#[nobold,dim]#{?window_zoomed_flag, $zoom_number, $custom_pane} #[fg=${THEME[yellow]}]#{?window_last_flag, , } "@' "${HOME}/.config/tmux/plugins/tokyo-night-tmux/tokyo-night.tmux"
else
  echo -e "\n==> Directory witj tmux tokyo-night plugindoes not exist "
fi

echo -e "\n==> Installing oh-my-posh with config"
rm -rf "${HOME}"/.config/ohmyposh
mkdir -p "${HOME}"/.config/ohmyposh
cp .config/ohmyposh/config.toml "${HOME}"/.config/ohmyposh/
sudo curl -s https://ohmyposh.dev/install.sh | sudo bash -s

cd ..
sudo rm -rf zsh-init

echo '
eval "$(oh-my-posh init zsh --config ${HOME}/.config/ohmyposh/config.toml)"
' >> "${HOME}"/.zshrc

echo -e "\n==> Done!"

zsh
