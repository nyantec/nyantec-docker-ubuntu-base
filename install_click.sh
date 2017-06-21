#!/bin/bash
# Provisioning script for click
set -ue

CLICK_TMPDIR="$(mktemp -d)"
trap 'rm -rf -- "$CLICK_TMPDIR"' EXIT

CLICK_PKG_URL="https://github.com/kohler/click/archive/e0d778d35d8f32934321e109b5c5cdeae415725f.tar.gz"
CLICK_PREFIX="/usr/local"

if [[ -e ${CLICK_PREFIX}/share/click/config.mk ]]; then
  exit 0 # click already installed
fi

wget "${CLICK_PKG_URL}" --quiet -O - | tar -xz -C "${CLICK_TMPDIR}"

(
  cd "${CLICK_TMPDIR}"/click-* &&
  ./configure \
      --disable-linuxmodule \
      --enable-user-multithread=yes \
      --enable-etherswitch=yes \
      --enable-ip6 \
      --prefix="${CLICK_PREFIX}" &&
  make &&
  sudo make install
)
