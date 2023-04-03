#!/bin/bash

# setup.sh

# font Operator Mono
# git clone https://github.com/keyding/Operator-Mono.git

# FIXME: change 'if' to 'case'
OS="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
git_version="v2.39.0"

if [[ "$OS" == "CentOS"* ]]; then
	echo -e "\n==> Linux distribution is: $OS"
  pmng="yum"
  bash=".bash_profile"
elif [[ "$OS" == "Red Hat"* ]]; then
  echo -e "\n==> Linux distribution is: $OS"
  pmng="yum"
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
if [[ "$OS" == "CentOS 7"* ]]; then
	sudo $pmng -y remove git*
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
	cd ~
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
else
  sudo $pmng -y install wget git tree
fi

echo -e "\n==> Setting git config parameters"
git config --global user.name "vertigojt"
git config --global user.email "vertigojt@null.domain"

echo -e "\n==> Setting colorscheme for vim"
mkdir -p ~/.vim/colors
git clone https://github.com/Rigellute/rigel.git
cp rigel/colors/rigel.vim ~/.vim/colors

cat >> ~/.vimrc << EOF
set termguicolors
syntax enable
colorscheme rigel
set autoindent expandtab tabstop=2 shiftwidth=2
hi Normal guibg=NONE ctermbg=NONE
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
sed -i 's/^plugins=(git.*/plugins=(git zsh-autosuggestions)/' ~/.zshrc

echo -e "\n==> Copying theme to oh-my-zsh folder"
cp vertigo.zsh-theme ~/.oh-my-zsh/themes/
echo -e "\n==> Enabling vertigo theme as default"
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="vertigo"/' ~/.zshrc

echo -e "\n==> Done!"
zsh
