VERSION := $(shell git describe --tags --dirty | sed 's/^v//')
export VERSION

PKGREL := 1
export PKGREL

.PHONY: all
all: tar deb pkgbuild homebrew

.PHONY: tar
tar:
	./make-tar.bash

.PHONY: deb
deb: tar
	./make-deb.bash

.PHONY: deb-install
deb-install: deb
	./deb-install.bash

.PHONY: pkgbuild
pkgbuild: tar
	./make-pkgbuild.bash

.PHONY: pkgbuild-install
pkgbuild-install: pkgbuild
	./pkgbuild-install.bash

.PHONY: homebrew
homebrew: tar
	./make-homebrew.bash

.PHONY: homebrew-install
homebrew-install: homebrew
	./homebrew-install.bash
