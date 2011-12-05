#########
# Install
#########

.PHONY: install
install: zsh hg screen vim xterm

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
	apt-get install git vim-gnome mercurial zsh xfonts-terminus screen \
			meld kdiff3

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
vim: $(HOME)/.vimrc
$(HOME)/.vimrc: .vimrc
	cp -a $< $@ 

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
