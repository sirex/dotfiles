#########
# Install
#########

.PHONY: install
install: zsh hg vim terminator buildout

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
	apt-get install git-core vim-gnome mercurial zsh xfonts-terminus \
	                terminator ack-grep silversearcher-ag python3

.PHONY: setup-server
setup-server:
	apt-get install git mercurial zsh screen ack-grep silversearcher-ag python3

#####
# bin
#####

.PHONY: bin
bin: $(HOME)/bin
$(HOME)/bin:
	mkdir -p $(HOME)/bin


#####
# ZSH
#####

.PHONY: zsh
zsh: $(HOME)/.zshrc
$(HOME)/.zshrc: .zshrc 
	git clone https://github.com/robbyrussell/oh-my-zsh.git $(HOME)/.oh-my-zsh
	cd ~ && ln -s .oh-my-zsh $(HOME)
	cp -a $< $@ 

.PHONY: uninstall-zsh
uninstall-zsh:
	rm -rf $(HOME)/.zshrc $(HOME)/.oh-my-zsh

###########
# Mercurial
###########

.PHONY: hg
hg: $(HOME)/.hgrc
$(HOME)/.hgrc: .hgrc bin/hgeditor bin
	ln -s $(PWD)/$< $@ 
	ln -s $(PWD)/bin/hgeditor $(HOME)/bin/hgeditor

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
	             $(HOME)/bin/vpaste \
		     vimpire
	mkdir -p $@

$(HOME)/.vimrc: .vimrc bin/vpaste
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

$(HOME)/bin/vpaste: bin/vpaste
	mkdir -p $(HOME)/bin
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

############
# Terminator
############

.PHONY: terminator
terminator: $(HOME)/.config/terminator/config
$(HOME)/.config/terminator/config: .config/terminator/config
	mkdir -p $(HOME)/.config/terminator
	cp -a $< $@

.PHONY: uninstall-terminator
uninstall-terminator:
	rm -rf $(HOME)/.config/terminator

############
# buildout
############

.PHONY: buildout
buildout: $(HOME)/.buildout/default.cfg
$(HOME)/.buildout/default.cfg: .buildout/default.cfg
	mkdir -p $(HOME)/.buildout/downloads
	mkdir -p $(HOME)/.buildout/eggs
	cp -a $< $@

.PHONY: uninstall-buildout
uninstall-buildout:
	rm -rf $(HOME)/.buildout
