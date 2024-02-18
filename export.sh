#!/bin/sh
rm -rf .godot/
rm -f build/linux_amd64/*

./pre_export.sh

mkdir -p build/linux_amd64/

godot4 --headless -e --quit

godot4 --headless -e --quit

godot4 -v --headless --export-release Linux-X11-amd64 build/linux_amd64/game
