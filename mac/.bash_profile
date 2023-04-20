# shellcheck shell=bash
# sourced by `bash --login`
if [ -n "$BASH_VERSION" ] ; then
  if [ -s "${HOME:?}/.bashrc" ] ; then
    source "${HOME}/.bashrc"
  fi
fi
