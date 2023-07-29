# ensure this works on both ubuntu and debian
image := mcr.microsoft.com/devcontainers/base:jammy # 1gb
# image := mcr.microsoft.com/devcontainers/base:bookworm # 1gb

# ensure this works in already provisioned environments
# image := mcr.microsoft.com/devcontainers/typescript-node:latest # 2gb
# image := mcr.microsoft.com/devcontainers/python:latest # 2gb

# this is the devcontainer for developing node core and it's 6gb
# image := nodejs/devcontainer:nightly

# this is the default devcontainer for codespaces and it's 18gb
# image := mcr.microsoft.com/devcontainers/universal:2-focal

.PHONY: docker docker-stop stop

# open a Bash shell in a container
docker:
	@docker run -it --rm --name=dotfiles -u 1000 -w /dotfiles -v $(PWD):/dotfiles -e GH_TOKEN=$(GH_TOKEN) $(image) bash

docker-stop:
	@docker stop dotfiles

# alias
stop: docker-stop
