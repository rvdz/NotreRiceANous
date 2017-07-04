#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import i3ipc
import os, sys, getpass

i3 = i3ipc.Connection()

def printData(data):
	sys.stdout.write(data)
	sys.stdout.flush()

def get_ws_icon(e):
	username = getpass.getuser()
	default_icon = " "
	title = i3.get_tree().find_focused().name.lower()
	wclass = i3.get_tree().find_focused().window_class
	
	if wclass is None:
		return default_icon
	wclass = wclass.lower()

	# titles
	engines = {
			"ecosia": " ",
			"google": " ",
			"lilo": "",
			"yahoo": " "
			}

	sites = {
			"amazon": " ",
			"apple": " ",
			"deviantart": "",
			"dropbox": " ",
			"github": " ",
			"maps": " ",
			"facebook": "",
			"imdb": " ",
			"instagram": " ",
			"lilo": "",
			"linkedin": " ",
			"mail": " ",
			"overleaf": " ",
			"paypal": " ",
			"pinterest": " ",
			"reddit": " ",
			"skype": " ",
			"slack": " ",
			"snapchat": " ",
			"soundcloud": " ",
			"spotify": " ",
			"stack exchange": " ",
			"stack overflow": " ",
			"steam": " ",
			"telegram": " ",
			"trello": " ",
			"tripadvisor": " ",
			"tumblr": "",
			"twitch": " ",
			"twitter": " ",
			"vimeo": " ",
			"vine": " ",
			"wikipedia": " ",
			"wordpress": " ",
			"yahoo": " ",
			"youtube": " "
			}

	term = {
			"vim": " "
			}

	# classes
	apps = {
			"telegram": " "
			}

	classes = {
			"terminal": " ", 
			"google-chrome": " ", 
			"chromium": " ", 
			"firefox": " "
			}

	icon = default_icon
	for key in apps.iterkeys():
		if key in wclass:
			return apps[key]

	for key in classes.iterkeys():
		if key in wclass:
			icon = classes[key]
			break

	if "terminal" in wclass:
		for key in term.iterkeys():
			if key in title:
				return term[key]
		return icon

	if "google-chrome" in wclass:
		title = title.replace("google chrome", "")

	for key in sites.iterkeys():
		if key in title:
			icon = sites[key]
	
	if icon == default_icon:
		return icon

	for key in engines.iterkeys():
		if key in title:
			return engines[key]
	return icon

def on_window_title(i3, e):
    printData(get_ws_icon(e))

i3.on("window::focus", on_window_title)
i3.on("window::title", on_window_title)
i3.on("workspace", on_window_title)

i3.main()
