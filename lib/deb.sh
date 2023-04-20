# shellcheck shell=bash
# Downloads a list of deb packages from GitHub releases and installs them with dpkg.
df_deb() {
  if [ "$(uname)" != 'Linux' ] ; then
    echo "df_deb: Unsupported OS $(uname -s)"
    return 1
  fi

  local -a args=("$@")
  local cwd="${BASH_SOURCE[0]:-$0}"
  source "$(dirname "$(realpath "$cwd")")/util/with_sudo.sh"

  for repo in "${args[@]}" ; do
    local bin=$(echo "$repo" | awk -F '/' '{print $2}')
    local token="${GH_TOKEN:-${GITHUB_TOKEN:-''}}"
    local arch=''
    local opts=''

    # set arch
    case "$(uname -m)" in
      aarch64|arm64) arch='arm64' ;;
      x86_64|amd64)  arch='amd64' ;;
      *)             echo "df_deb: Unsupported architecture: $(uname -m)" ; return 1 ;;
    esac

    # GitHub CLI is installed as `gh`
    if [ "$repo" = 'cli/cli' ] ; then
      bin='gh'
      arch="linux_${arch}"
    fi

    # already installed
    if command -v "$bin" >/dev/null ; then
      continue
    fi

    # use GitHub token if available
    if [ -n "$token" ] ; then
      opts="-fsSLH 'Authorization: token $token'"
    else
      opts='-fsSL'
    fi

    # get the latest release
    local assets=$(eval "curl $opts https://api.github.com/repos/$repo/releases/latest" | jq -r '.assets')
    local asset="$(echo "$assets" | jq -r ".[] | select(.name | test(\"${bin}_(.+)_${arch}.deb\"))")"

    # no deb
    if [ -z "$asset" ] ; then
      echo "df_deb: $repo deb not found"
      return 1
    fi

    # download the deb
    sleep 0.1
    local browser_download_url=$(echo "$asset" | jq -r '.browser_download_url')
    local filename=$(basename "$browser_download_url")
    eval "curl -fsSL $browser_download_url -o /tmp/$filename"

    # install and cleanup
    with_sudo dpkg -i "/tmp/$filename"
    rm -f "/tmp/$filename"
  done
}
