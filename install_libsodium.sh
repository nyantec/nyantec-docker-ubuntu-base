#!/bin/bash
# Installs libsodium
set -ue

LIBSODIUM_TMPDIR="$(mktemp -d)"
trap 'rm -rf -- "$LIBSODIUM_TMPDIR"' EXIT

LIBSODIUM_PKG_URL="https://download.libsodium.org/libsodium/releases/libsodium-1.0.11.tar.gz"
LIBSODIUM_PREFIX="/usr/local"

cat > "${LIBSODIUM_TMPDIR}"/test_libsodium.cc <<EOF
#include <sodium/crypto_core_hchacha20.h>
#include <sodium/crypto_stream_chacha20.h>
#include <sodium/crypto_onetimeauth_poly1305.h>

int main() {
  crypto_core_hchacha20(NULL, NULL, NULL, NULL);
  return 0;
}
EOF

if c++ \
      "${LIBSODIUM_TMPDIR}"/test_libsodium.cc \
      -o "${LIBSODIUM_TMPDIR}"/test_libsodium \
      $(pkg-config --libs libsodium) &> /dev/null; then
  exit 0 # libsodium up to date
fi

wget "${LIBSODIUM_PKG_URL}" --quiet -O - | tar -xz -C "${LIBSODIUM_TMPDIR}"

(
  cd "${LIBSODIUM_TMPDIR}"/libsodium-* &&
  ./configure --prefix="${LIBSODIUM_PREFIX}"
  make &&
  make check &&
  sudo make install
)

sudo bash -c "echo ${LIBSODIUM_PREFIX}/lib > /etc/ld.so.conf.d/libsodium.conf"

sudo ldconfig
