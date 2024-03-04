#!/bin/bash


OS="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
git_version="v2.39.0"

if [[ "$OS" == "CentOS"* ]]; then
  echo -e "\n==> Linux distribution is: $OS"
  pmng="yum"
  bash=".bash_profile"
elif [[ "$OS" == *"Red Hat"* ]]; then
  echo -e "\n==> Linux distribution is: $OS"
  pmng="yum"
  bash=".bash_profile"
elif [[ "$OS" == *"Rocky"* ]]; then
  echo -e "\n==> Linux distribution is: $OS"
  pmng="dnf"
  bash=".bash_profile"
elif [[ "$OS" == "Ubuntu"* ]]; then
  echo -e "\n==> Linux distribution is: $OS"
  pmng="apt"
  bash=".bashrc" # FIXME
elif [[ "$OS" == "Debian"* ]]; then
  echo -e "\n==> Linux distribution is: $OS"
  pmng="apt"
  bash=".bashrc" # FIXME
else
  echo -e "\n==> Unknown Linux distribution"; exit;
fi

echo -e "\n==> Installing wget git tree"
if [[ "$OS" == "CentOS Linux release 7"* ]]; then
  sudo $pmng -y remove git
  sudo $pmng -y install epel-release
  sudo $pmng -y groupinstall "Development Tools"
  sudo $pmng -y install wget tree perl-CPAN gettext-devel perl-devel openssl-devel \
  zlib-devel curl-devel expat-devel getopt asciidoc xmlto docbook2X
  sudo ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi
  wget https://github.com/git/git/archive/$git_version.tar.gz
  tar -xvf $git_version.tar.gz
  rm -f $git_version.tar.gz
  cd git-*
  make configure
  sudo ./configure --prefix=/usr
  sudo make
  sudo make install
  cd ..
  echo "==> Installing vim"
  sudo $pmng install -y gcc make ncurses ncurses-devel
  sudo $pmng install -y ctags git tcl-devel ruby ruby-devel lua lua-devel luajit luajit-devel \
  python python-devel perl perl-devel perl-ExtUtils-ParseXS perl-ExtUtils-XSpp \
  perl-ExtUtils-CBuilder perl-ExtUtils-Embed
  sudo $pmng remove -y vim-enhanced vim-common vim-filesystem

  echo "==> Cloning vim repository"
  git clone https://github.com/vim/vim.git
  cd vim

  echo "Compiling vim"
  ./configure --with-features=huge --enable-multibyte --enable-rubyinterp \
  --enable-pythoninterp --enable-perlinterp --enable-luainterp
  make
  sudo make install
  source ~/$bash
  cd ..
else
  sudo $pmng -y install wget git tree jq
fi

if [[ "$OS" == "Ubuntu"* ]]; then
  echo -e "\n==> Installing bat"
  sudo $pmng install -y bat
fi

echo -e "\n==> Setting git config parameters"
git config --global user.name "vertigojt"
git config --global user.email "vertigojt@null.domain"

echo -e "\n==> 🌈 Setting colorscheme for vim 🌈"
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
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo -e "\n==> Enabling plugins in ~/.zshrc"
sed -i 's/^plugins=(git.*/plugins=(git zsh-autosuggestions kube-ps1)/' ~/.zshrc

echo -e "\n==> Copying theme to oh-my-zsh folder"
cp vertigo.zsh-theme ~/.oh-my-zsh/themes/

echo -e "\n==> Enabling vertigo theme as default"
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="vertigo"/' ~/.zshrc

if batcat --help &> /dev/null; then
  echo -e "\n==> Setting theme for batcat"
  mkdir -p "$(batcat --config-dir)/themes"
  curl --output-dir "$(batcat --config-dir)/themes" -LO https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
  curl --output-dir "$(batcat --config-dir)/themes" -LO https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
  curl --output-dir "$(batcat --config-dir)/themes" -LO https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
  curl --output-dir "$(batcat --config-dir)/themes" -LO https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
  batcat cache --build
  echo 'export BAT_THEME="Catppuccin%20Mocha"' >> ~/.zshrc
fi

echo -e "\n==> Adding aliases to ~/.zshrc file"
echo '
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

alias d="docker"
alias dp="docker ps"
alias dpa="docker ps -a"
alias di="docker images"

alias t="tkn"

alias sss="ss -tulpna | grep -i listen"
alias ssss="sudo ss -tulpna | grep -i listen"

alias tf="terraform"
alias tfp="terraform plan"
alias tfaa="terraform apply -auto-approve"

alias gi="git init ."
alias gl="git log"
alias ga="git add -A"
alias gs="git status"
alias gc="git commit -m "
alias gd="git diff"
alias gpom="git push origin master"

alias au="sudo apt update"
alias aup="sudo apt update -y"
alias status="systemctl status "

alias zshup="rm -rf ~/.oh-my-zsh && git clone https://github.com/jtvertigo/zsh-init && cd zsh-init && ./initial.sh"

export EDITOR="$(which vim)"
export VISUAL=$EDITOR
export SYSTEMD_EDITOR=$EDITOR' >> ~/.zshrc

if [[ "$OS" == "Ubuntu"* ]]; then
echo '
alias cat="batcat"
alias ccat="/usr/bin/cat"' >> ~/.zshrc
fi

if [[ "$OS" == *"Rocky"* ]]; then
  echo -e "\n==> Making zsh as default shell"
  sudo usermod -s $(which zsh) ${USER}
fi

if kubectl &> /dev/null; then
  echo -e "\n==> Adding autocompletion for kubectl"
  echo '[[ $commands[kubectl] ]] && source <(kubectl completion zsh)' >> ~/.zshrc
fi

if tkn &> /dev/null; then
  echo -e "\n==> Adding autocompletion for tekton"
  echo '[[ $commands[tkn] ]] && source <(tkn completion zsh)' >> ~/.zshrc
fi

if helm &> /dev/null; then
  echo -e "\n==> Adding autocomletion for helm"
  # helm completion zsh > "${fpath[1]}/_helm"
  echo '[[ $commands[helm] ]] && source <(helm completion zsh)' >> ~/.zshrc
fi

echo '
if kubectl &> /dev/null; then
  kubeon
else
  kubeoff
fi
if [ -e $HOME/.kube/config ]; then
  export KUBECONFIG=$HOME/.kube/config
fi' >> ~/.zshrc

vim +PlugInstall +qall

echo -e "\n==> 🌈 Setting theme for airline 🌈"
cp vim/autoload/airline/themes/catppuccin_*.vim ~/.vim/plugged/vim-airline-themes/autoload/airline/themes

cd ..

sudo rm -rf zsh-init

echo -e "\n==> Done!"
zsh
