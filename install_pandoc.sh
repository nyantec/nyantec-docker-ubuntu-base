#!/bin/sh

set -ue

cabal update
cabal install --global 'pandoc >= 1.19.2.1' 'pandoc-crossref >= 0.2.5.0'
