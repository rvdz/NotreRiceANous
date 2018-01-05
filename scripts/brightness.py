#!/usr/bin/env python
# -*- coding: utf-8 -*-

import i3ipc
import sys, os

def get_brightness():
    return os.popen("bash ~/Config/NotreRiceANous/scripts/getbrightness.sh").read()

def printData(data):
    sys.stdout.write(data)
    sys.stdout.flush()

i3 = i3ipc.Connection()
printData(get_brightness())

def on_brightness_change(self, e):
    printData(get_brightness())

i3.on('binding', on_brightness_change)
i3.main()
