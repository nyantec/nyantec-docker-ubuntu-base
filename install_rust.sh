#!/bin/bash
set -ue

# FIXME this script is only required since ubuntu 14.0 has an old rustc that
# gives parse errors on .toml files. Once we're dropping support for ubuntu14,
# this file should be removed and the rustc package added to packages_apt.txt
# instead (rustc from later ubuntu versions will work fine)

: ${RUST_TMPDIR:=/tmp/rust_install}
: ${RUST_PKG_URL:="https://static.rust-lang.org/dist/rust-1.16.0-x86_64-unknown-linux-gnu.tar.gz"}
: ${RUST_PREFIX:="/usr/local"}

if which rustc &> /dev/null; then
  exit 0 # rust already installed
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
