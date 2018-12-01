#!/usr/bin/env python
# -*- coding: utf-8 -*-
import subprocess as sp
import sys
import i3ipc
import time


cmd = ["playerctl", "metadata"]


def get_title():
    return sp.check_output(cmd + ["title"])[:-1].decode("utf-8")


def get_artist():
    return sp.check_output(cmd + ["artist"])[:-1].decode("utf-8")


def is_playing():
    status = sp.check_output(["playerctl", "status"])[:-1].decode("utf-8")
    return status == "Playing"


def print_string(msg):
    sys.stdout.write(msg)
    sys.stdout.flush()


def on_track_change(self, e):
    # Wait for the player to start/stop before checking its new status
    time.sleep(0.1)
    if is_playing():
        print_string("{} - {}".format(get_artist(), get_title()))
    else:
        print("")
        sys.stdout.flush()


i3 = i3ipc.Connection()
i3.on("binding", on_track_change)
i3.main()
