#!/bin/sh

for f in apps/*; do
  dir="$(pwd)"
  if [ -f "$f/assets/package.json" ]; then
    cd "$f/assets" || return
    yarn install
    yarn run deploy
    cd "$dir" || return
  fi
done
