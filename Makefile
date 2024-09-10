# ensure this works on both ubuntu (jammy) and debian (bookworm)
image := mcr.microsoft.com/devcontainers/base:jammy # 1gb
# image := mcr.microsoft.com/devcontainers/base:bookworm # 1gb

.PHONY: docker stop

# usage:
#   make
#   make stop
docker:
	@docker run -it --rm --name=dotfiles -u 1000 -w /dotfiles -v $(PWD):/dotfiles -e GH_TOKEN=$(GH_TOKEN) $(image) bash

stop:
	@docker stop dotfiles
