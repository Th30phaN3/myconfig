#!/bin/sh
#
# Install custom .nanorc syntax highlighting files
# from https://github.com/scopatz/nanorc

# Check for unzip before we continue
if [ ! "$(command -v unzip)" ]; then
  echo 'unzip is required but was not found. Install unzip first and then run this script again.' >&2
  exit 1
fi

# Check for wget before we continue
if [ ! "$(command -v wget)" ]; then
  echo 'wget is required but was not found. Install wget first and then run this script again.' >&2
  exit 1
fi

SYNTAX_DIR=~/.config/nano/syntax/

_fetch_sources() {
  wget -O /tmp/nanorc.zip https://github.com/scopatz/nanorc/archive/master.zip
  mkdir -p "${SYNTAX_DIR}"
  cd "${SYNTAX_DIR}" || exit
  \rm *
  unzip -o "/tmp/nanorc.zip"
  \mv nanorc-master/*.nanorc ./
  \rm -rf nanorc-master
  \rm /tmp/nanorc.zip
}

_fetch_sources;
