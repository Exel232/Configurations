BASEDIR := $(shell pwd)
HOST = $(shell hostname)
export BASEDIR
export HOST


DOTS = Dotfiles
HOSTSDIR = Hosts

include packaging.mk stow.mk

.PHONY: all
all: bspwm apps base

# DESKTOPS
.PHONY: bspwm
bspwm:
	$(MAKE) -C Dotfiles/bspwm

# APPS
.PHONY: apps
apps: newsboat zimwiki nextcloud keepassxc redshift

.PHONY: newsboat
newsboat: newsboat.stow newsboat.pkg

.PHONY: zimwiki
zimwiki: zimwiki.stow zim.pkg

.PHONY: nextcloud
nextcloud: nextcloud-client.aur

.PHONY: keepassxc
keepassxc: keepassxc.pkg

.PHONY: redshift
redshift: redshift.pkg

# BASE PROGRAMS
.PHONY: base
base: tmux neovim fish st basefonts keyboard chinese

.PHONY: tmux
tmux: tmux.stow tmux.pkg
	@echo "Issue C-a I to install packages defined in .tmux.conf."

.PHONY: neovim
neovim: neovim.stow neovim.pkg

.PHONY: fish
fish: fish.stow fish.pkg
	@curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
	@fish -c "fisher edc/bass"

.PHONY: st
.ONESHELL:
st: ncurses terminess-powerline-font-git.aur
	@if [ hostname = "Z20T" ]; then
		FONTSIZE=12
	else
		FONTSIZE=11
	fi
	if [ -z "`pacman -Qs | grep "/$@ 0.8.1"`" ]; then
		cd packages/$@
		FONTSIZE=$$FONTSIZE makepkg -sf
		sudo pacman -U --noconfirm $@*.pkg.tar*
	else
		echo "$@ already installed."
	fi

.PHONY: ncurses
.ONESHELL:
ncurses:
	@if [ "`pacman -Qs | grep "/$@ 6.1-3"`" ]; then
		cd packages/$@
		makepkg -s
		sudo pacman -U --noconfirm $@*.pkg.tar*
	else
		echo "$@ already current."
	fi

.PHONY: keyboard
keyboard: keyboard.stow xcape.pkg
	@systemctl --user enable --now xcape.service
	@systemctl --user enable --now xkbload.service

.PHONY: chinese
chinese: ibus.pkg ibus-rime.pkg wqy-microhei.pkg wqy-zenhei.pkg

.PHONY: basefonts
basefonts: otf-overpass.pkg noto-fonts.pkg cantarell-fonts.pkg
