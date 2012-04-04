#########
# Install
#########

.PHONY: install
install: zsh hg screen vim xterm

.PHONY: server
server: zsh hg screen vim

###########
# Uninstall
###########

.PHONY: uninstall
uninstall: uninstall-zsh uninstall-xterm

#######
# Setup
#######

.PHONY: setup
setup:
	apt-get install git-core vim-gnome mercurial zsh xfonts-terminus screen \
			meld kdiff3 ack-grep python3

.PHONY: setup-server
setup-server:
	apt-get install git mercurial zsh screen ack-grep python3

#####
# ZSH
#####

.PHONY: zsh
zsh: $(HOME)/.zshrc
$(HOME)/.zshrc: .zshrc 
	git clone https://github.com/robbyrussell/oh-my-zsh.git $(HOME)/.oh-my-zsh
	cp -a .oh-my-zsh $(HOME)
	cp -a $< $@ 

.PHONY: uninstall-zsh
uninstall-zsh:
	rm -rf $(HOME)/.zshrc $(HOME)/.oh-my-zsh

###########
# Mercurial
###########

.PHONY: hg
hg: $(HOME)/.hgrc
$(HOME)/.hgrc: .hgrc
	cp -a $< $@ 

########
# screen
########

.PHONY: screen
screen: $(HOME)/.screenrc
$(HOME)/.screenrc: .screenrc
	cp -a $< $@ 

#####
# Vim
#####

.PHONY: vim
vim: $(HOME)/.vim/bundle
$(HOME)/.vim/bundle: $(HOME)/.vimrc \
                     $(HOME)/.vim/var/swap \
                     $(HOME)/.vim/var/undo  \
                     $(HOME)/.vim/var/backup \
		     vimpire
	mkdir -p $@

$(HOME)/.vimrc: .vimrc
	cp -a $< $@ 

$(HOME)/.vim/var/swap:
	mkdir -p $@

$(HOME)/.vim/var/undo:
	mkdir -p $@

$(HOME)/.vim/var/backup:
	mkdir -p $@

.PHONY: vimpire
vimpire: $(HOME)/.vim/vimpire.py $(HOME)/.vim/autoload/pathogen.vim
	python3 $<

$(HOME)/.vim/vimpire.py:
	wget -q http://bitbucket.org/sirex/vimpire/raw/tip/vimpire.py -O $@

$(HOME)/.vim/autoload/pathogen.vim: $(HOME)/.vim/autoload
	wget -q 'http://www.vim.org/scripts/download_script.php?src_id=16224' -O $@

$(HOME)/.vim/autoload:
	mkdir -p $@

#######
# XTerm
#######

.PHONY: xterm
xterm: $(HOME)/.xinitrc
$(HOME)/.xinitrc: .xinitrc
	cp -a $< .Xresources .xrdb $(HOME)
	xrdb -merge $(HOME)/.Xresources

.PHONY: uninstall-xterm
uninstall-xterm:
	rm -rf $(HOME)/.xinitrc $(HOME)/.Xresources $(HOME)/.xrdb
