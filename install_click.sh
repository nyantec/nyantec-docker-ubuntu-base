#!/bin/bash
set -ue

: ${CLICK_TMPDIR:=/tmp/click_install}
: ${CLICK_PKG_URL:="https://github.com/kohler/click/archive/e0d778d35d8f32934321e109b5c5cdeae415725f.tar.gz"}
: ${CLICK_PREFIX:="/usr/local"}

if [[ -z ${CLICK_TMPDIR} || ${#CLICK_TMPDIR} -lt 3 ]]; then
  echo "invalid tmpdir: ${CLICK_TMPDIR}" 1>&2
  exit 1
fi

rm -rf ${CLICK_TMPDIR}
mkdir -p ${CLICK_TMPDIR}

wget "${CLICK_PKG_URL}" --quiet -O - | tar -xz -C ${CLICK_TMPDIR}

(
  cd ${CLICK_TMPDIR}/click-* &&
  ./configure \
      --disable-linuxmodule \
      --enable-user-multithread=yes \
      --enable-ip6 \
      --prefix="${CLICK_PREFIX}" &&
  make &&
  sudo make install
)
