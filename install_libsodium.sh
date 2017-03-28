#!/bin/bash
set -ue

: ${LIBSODIUM_TMPDIR:=/tmp/libsodium_install}
: ${LIBSODIUM_PKG_URL:="https://download.libsodium.org/libsodium/releases/libsodium-1.0.11.tar.gz"}
: ${LIBSODIUM_PREFIX:="/usr/local"}

if [[ -z ${LIBSODIUM_TMPDIR} || ${#LIBSODIUM_TMPDIR} -lt 3 ]]; then
  echo "invalid tmpdir: ${LIBSODIUM_TMPDIR}" 1>&2
  exit 1
fi

rm -rf ${LIBSODIUM_TMPDIR}
mkdir -p ${LIBSODIUM_TMPDIR}

wget "${LIBSODIUM_PKG_URL}" --quiet -O - | tar -xz -C ${LIBSODIUM_TMPDIR}

(
  cd ${LIBSODIUM_TMPDIR}/libsodium-* &&
  ./configure --prefix="${LIBSODIUM_PREFIX}"
  make &&
  make check &&
  sudo make install
)

sudo bash -c "echo ${LIBSODIUM_PREFIX}/lib > /etc/ld.so.conf.d/libsodium.conf"
sudo ldconfig

