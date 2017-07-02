#!/usr/bin/env python

import i3ipc
import os, sys

i3 = i3ipc.Connection()

def printData(data):
	sys.stdout.write(data)
	sys.stdout.flush()

def get_ws_icon():
	return os.popen("bash ~/NotreRiceANous/scripts/workspace.sh").read()

def on_window_title(i3, e):
    printData(get_ws_icon())

i3.on("window::focus", on_window_title)
i3.on("window::title", on_window_title)

i3.main()
