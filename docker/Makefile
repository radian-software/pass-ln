.PHONY: deb-shell
deb-shell:
	./build-dockerfile.bash deb
	./run-in-docker.bash pass-ln-deb bash -l

.PHONY: rpm-shell
rpm-shell:
	./build-dockerfile.bash rpm
	./run-in-docker.bash pass-ln-rpm bash -l

.PHONY: pkgbuild-shell
pkgbuild-shell:
	./build-dockerfile.bash pkgbuild
	./run-in-docker.bash pass-ln-pkgbuild bash -l

.PHONY: homebrew-shell
homebrew-shell:
	./build-dockerfile.bash homebrew
	./run-in-docker.bash pass-ln-homebrew bash -l

.PHONY: pass-setup
pass-setup:
	./pass-setup.bash
