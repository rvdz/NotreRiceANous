#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import i3ipc
import os, sys, getpass

i3 = i3ipc.Connection()

def printData(data):
	sys.stdout.write(data)
	sys.stdout.flush()

def get_ws_icon():
	title = i3.get_tree().find_focused().name.lower()
	wclass = i3.get_tree().find_focused().window_class.lower()
	username = getpass.getuser()
	icon = "☯"  # default icon

	# titles
	engines = {
			"ecosia": " ",
			"google": " "
			}

	sites = {
			"stack overflow": " ",
			"youtube": " ",
			"github": " ",
			"reddit": " ",
			"wikipedia": " ",
			"telegram": " ",
			"amazon": " ",
			"apple": " ",
			"facebook": ""
			}

	# classes
	apps = {
			"terminal": " ", 
			"telegram": " "
			}

	classes = {
			"chrome": " ", 
			"firefox": " "
			}

	for key in apps.iterkeys():
		if key in wclass:
			return apps[key]
	for key in classes.iterkeys():
		if key in wclass:
			icon = classes[key]
			break
	for key in sites.iterkeys():
		if key in title:
			return sites[key]
	return icon

def on_window_title(i3, e):
    printData(get_ws_icon())

i3.on("window::focus", on_window_title)
i3.on("window::title", on_window_title)

i3.main()
