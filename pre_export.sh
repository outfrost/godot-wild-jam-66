#!/bin/sh
mkdir -p .godot/
if [ ! -f '.godot/extension_list.cfg' ]; then
	echo "res://addons/fmod/fmod.gdextension" > .godot/extension_list.cfg
fi
