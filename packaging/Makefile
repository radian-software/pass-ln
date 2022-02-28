VERSION := $(shell git describe --tags --dirty | sed 's/^v//')
export VERSION

.PHONY: all
all: deb pkgbuild homebrew tar

.PHONY: deb
deb:
	./make-deb.bash

.PHONY: deb-install
deb-install: deb
	./deb-install.bash

.PHONY: pkgbuild
pkgbuild:
	./make-pkgbuild.bash

.PHONY: pacman-install
pacman-install:
	./pacman-install.bash

.PHONY: homebrew
homebrew: tar
	./make-homebrew.bash

.PHONY: homebrew-install
homebrew-install: homebrew
	./homebrew-install.bash

.PHONY: tar
tar:
	./make-tar.bash
