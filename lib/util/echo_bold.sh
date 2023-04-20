# shellcheck shell=bash
echo_bold() {
  local -a args=("$@")

  # -t 1 means stdout is a terminal
  if [ ! -t 1 ] ; then
    echo "${args[*]}"
    return
  fi

  echo -e "\e[1m\e[37m${args[*]}\e[0m"
}
