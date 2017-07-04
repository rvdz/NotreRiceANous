#!/usr/bin/env python

import i3ipc
import os, sys, getpass

i3 = i3ipc.Connection()

def printData(data):
	sys.stdout.write(data)
	sys.stdout.flush()

def get_ws_icon():
	title = i3.get_tree().find_focused().name.lower()
	wclass = i3.get_tree().find_focused().window_class.lower()
	print title, wclass
	username = getpass.getuser()
	icon = ""

	dict = {"chrome": "cr", "terminal": "term"}

	for key in dict.iterkeys():
		if key in wclass:
			print key

	if "google-chrome" in wclass or "chromium" in wclass:
		icon = "chrome"

	if "google chrome" in title or "chromium" in title:
		icon = "chrome"
	if "firefox" in title:
		icon = "firefox"


	if icon != "":
		if "stack overflow" in title:
			icon = "so"
		if "youtube" in title:
			icon = "yt"
		if "wikipedia" in title:
			icon = "wiki"
		if "github" in title:
			icon = "gh"
		if "facebook" in title:
			icon = "fb"
		if "twitch" in title:
			icon = "tw"
		if "amazon" in title:
			icon = "az"
	else:
		if "vim" in title:
			icon = "vi"
		if username + "@" in title:
			icon = "term"
	return icon
		


def on_window_title(i3, e):
    printData(get_ws_icon())

i3.on("window::focus", on_window_title)
i3.on("window::title", on_window_title)

i3.main()
