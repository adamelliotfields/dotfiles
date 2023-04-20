.PHONY: docker

IMAGE := mcr.microsoft.com/devcontainers/base:ubuntu

# open a Bash shell in an Ubuntu container
docker:
	@docker run -it --rm -u vscode -w /dotfiles -v $(PWD):/dotfiles -e "GH_TOKEN=$(GH_TOKEN)" $(IMAGE) bash
