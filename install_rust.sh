#!/bin/bash
set -ue

: ${RUST_TMPDIR:=/tmp/rust_install}
: ${RUST_PKG_URL:="https://static.rust-lang.org/dist/rust-1.16.0-x86_64-unknown-linux-gnu.tar.gz"}
: ${RUST_PREFIX:="/usr/local"}

if which rustc &> /dev/null; then
  echo 0
  #exit 0 # rust already installed
fi

if [[ -z ${RUST_TMPDIR} || ${#RUST_TMPDIR} -lt 3 ]]; then
  echo "invalid tmpdir: ${RUST_TMPDIR}" 1>&2
  exit 1
fi

rm -rf ${RUST_TMPDIR}
mkdir -p ${RUST_TMPDIR}

wget "${RUST_PKG_URL}" --quiet -O - | tar -xz -C ${RUST_TMPDIR}

(
  cd ${RUST_TMPDIR}/rust-* &&
  sudo ./install.sh
)
