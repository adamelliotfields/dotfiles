# shellcheck shell=bash
if [ -n "$BASH_VERSION" ] ; then
  if [ -s "${HOME:?}/.bashrc" ] ; then
    source "${HOME}/.bashrc"
  fi
fi
