SHELL = bash

.PHONY: all
all: zsh hg screen vim xterm

.PHONY: uninstall
uninstall: uninstall-zsh uninstall-xterm

.PHONY: setup
setup:
	apt-get install git vim-gnome mercurial zsh xfonts-terminus screen \
			meld kdiff3

.PHONY: zsh
zsh: $(HOME)/.zshrc
$(HOME)/.zshrc: .zshrc 
	git clone https://github.com/robbyrussell/oh-my-zsh.git $(HOME)/.oh-my-zsh
	cp -a .oh-my-zsh $(HOME)
	cp -a $< $@ 

.PHONY: uninstall-zsh
uninstall-zsh:
	rm -rf $(HOME)/.zshrc $(HOME)/.oh-my-zsh

.PHONY: hg
hg: $(HOME)/.hgrc
$(HOME)/.hgrc: .hgrc
	cp -a $< $@ 

.PHONY: screen
screen: $(HOME)/.screenrc
$(HOME)/.screenrc: .screenrc
	cp -a $< $@ 

.PHONY: vim
vim: $(HOME)/.vimrc
$(HOME)/.vimrc: .vimrc
	cp -a $< $@ 

.PHONY: xterm
xterm: $(HOME)/.xinitrc
$(HOME)/.xinitrc: .xinitrc
	cp -a $< .Xresources .xrdb $(HOME)
	xrdb -merge $(HOME)/.Xresources

.PHONY: uninstall-xterm
uninstall-xterm:
	rm -rf $(HOME)/.xinitrc $(HOME)/.Xresources $(HOME)/.xrdb
