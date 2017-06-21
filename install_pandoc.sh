#!/bin/sh

set -ue

PANDOC_PKG_URL="https://github.com/jgm/pandoc/releases/download/1.19.2.1/pandoc-1.19.2.1-1-amd64.deb"

pandoc_tmp="$(mktemp -d)"
trap 'rm -rf -- "$pandoc_tmp"' EXIT

cd "$pandoc_tmp"
curl --silent --show-error --location --remote-name "$PANDOC_PKG_URL"
dpkg --install *.deb
