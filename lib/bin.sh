# downloads supported binaries from GitHub releases and installs to /usr/local/bin
function dotfiles_bin {
  # run as sudo if not root
  function _sudo {
    [[ $EUID -ne 0 ]] && sudo "$@" || "$@"
  }

  # force install
  local force=0
  local -a names=()
  for arg in "$@" ; do
    case "$arg" in
      -f|--force) force=1 ;;
      *)          names+=("$arg") ;;
    esac
  done

  # delay between requests when unauthenticated
  local DELAY=1

  # prefer GH_TOKEN
  local token="${GITHUB_TOKEN:-}"
  local token="${GH_TOKEN:-$token}"

  local os arch
  os=$(uname -s)
  arch=$(uname -m)

  if [[ "$os" != 'Linux' ]] ; then
    echo 'dotfiles_bin: Unsupported OS'
    return 1
  fi

  if ! command -v jq >/dev/null 2>&1 ; then
    echo 'dotfiles_bin: install jq'
    return 1
  fi

  # no ARM
  if [[ " ${names[*]} " == *' magick '* ]] && [[ "$arch" != 'x86_64' ]] ; then
    echo 'dotfiles_bin: magick AppImage is amd64 only'
    return 1
  fi

  # set arch strings for each naming convention
  local arch_gnu='' arch_simple='' arch_htmlq='' arch_micro='' arch_node=''
  case "$arch" in
    aarch64|arm64)
      arch_gnu='aarch64-unknown-linux-gnu'
      arch_simple='arm64'
      arch_node='arm64'
      arch_htmlq='aarch64-linux'
      arch_micro='linux-arm64'
      ;;
    x86_64|amd64)
      arch_gnu='x86_64-unknown-linux-gnu'
      arch_simple='amd64'
      arch_node='x64'
      arch_htmlq='x86_64-linux'
      arch_micro='linux64'
      ;;
    *)
      echo 'dotfiles_bin: Unsupported architecture'
      return 1
      ;;
  esac

  local opts=(-fsSL)
  if [[ -n "$token" ]] ; then
    echo 'dotfiles_bin: Using GitHub API token...'
    opts+=(-H "Authorization: token $token")
    DELAY=0
  fi

  for name in "${names[@]}" ; do
    local repo='' pattern=''
    case "$name" in
      codex)     repo='openai/codex'            ; pattern="codex-${arch_gnu}\.tar\.gz" ;;
      copilot)   repo='github/copilot-cli'      ; pattern="copilot-linux-${arch_node}\.tar\.gz" ;;
      fastfetch) repo='fastfetch-cli/fastfetch' ; pattern="fastfetch-linux-${arch_simple}\.tar\.gz" ;;
      fzf)       repo='junegunn/fzf'            ; pattern="fzf-.+-linux_${arch_simple}\.tar\.gz$" ;;
      gh)        repo='cli/cli'                 ; pattern="gh_.+_linux_${arch_simple}\.tar\.gz" ;;
      hcloud)    repo='hetznercloud/cli'        ; pattern="hcloud-linux-${arch_simple}\.tar\.gz" ;;
      htmlq)     repo='mgdm/htmlq'              ; pattern="htmlq-${arch_htmlq}\.tar\.gz" ;;
      lf)        repo='gokcehan/lf'             ; pattern="lf-linux-${arch_simple}\.tar\.gz" ;;
      magick)    repo='imagemagick/imagemagick' ; pattern='clang-x86_64\.AppImage$' ;;
      micro)     repo='micro-editor/micro'      ; pattern="micro-.+-${arch_micro}\.tar\.gz$" ;;
      opencode)  repo='anomalyco/opencode'      ; pattern="opencode-linux-${arch_node}\.tar\.gz" ;;
      *)
        echo "dotfiles_bin: Unsupported binary '$name'"
        return 1
        ;;
    esac

    # already installed
    if [[ "$force" -eq 0 ]] && command -v "$name" >/dev/null 2>&1 ; then
      continue
    fi

    # get the latest release assets
    local assets
    assets=$(curl "${opts[@]}" "https://api.github.com/repos/$repo/releases/latest" | jq -r '.assets')

    local asset browser_download_url filename
    asset=$(echo "$assets" | jq -r --arg p "$pattern" '.[] | select(.name | test($p))')

    if [[ -z "$asset" ]] ; then
      echo "dotfiles_bin: $name asset not found"
      return 1
    fi

    browser_download_url=$(echo "$asset" | jq -r '.browser_download_url')
    filename=$(basename "$browser_download_url")

    sleep $DELAY && curl -fsSL -o "/tmp/$filename" "$browser_download_url"

    # extract or copy to /usr/local/bin
    if [[ "$filename" == *.tar.gz ]] ; then
      local extract_dir="/tmp/dotfiles_bin_$$"
      mkdir -p "$extract_dir"
      tar -xzf "/tmp/$filename" -C "$extract_dir"

      # find the binary
      local bin_path
      bin_path=$(find "$extract_dir" -type f -name "$name" | head -n1)
      [[ -z "$bin_path" ]] && bin_path=$(find "$extract_dir" -type f | head -n1)

      chmod +x "$bin_path"
      _sudo mv "$bin_path" "/usr/local/bin/$name"
      rm -rf "$extract_dir"
    else
      # direct executable
      chmod +x "/tmp/$filename"
      _sudo mv "/tmp/$filename" "/usr/local/bin/$name"
    fi

    rm -f "/tmp/$filename"
  done
}
