#!/usr/bin/env python
# -*- coding: utf-8 -*-

import i3ipc
import sys, os

def get_sound_volume():
    return os.popen("sh ~/NotreRiceANous/scripts/getvolume.sh").read()

def printData(data):
    sys.stdout.write(data)
    sys.stdout.flush()

i3 = i3ipc.Connection()
printData(get_sound_volume())

def on_sound_change(self, e):
    printData(get_sound_volume())

i3.on('binding', on_sound_change)
i3.main()
