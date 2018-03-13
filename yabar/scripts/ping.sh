#!/bin/bash

echo " $(ping 8.8.8.8 -c 1 | grep "time=" | sed -r 's/^.*time=([0-9]+).*$/\1/g') ms"
