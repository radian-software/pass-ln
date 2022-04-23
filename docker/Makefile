.PHONY: homebrew-shell
homebrew-shell:
	./build-dockerfile.bash homebrew
	./run-in-docker.bash pass-ln-homebrew bash -l

.PHONY: pass-setup
pass-setup:
	./pass-setup.bash
