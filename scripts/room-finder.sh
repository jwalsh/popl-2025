#!/bin/bash

ROOM="$1"
TIME="$2"

if [ -z "$ROOM" ]; then
    echo "Usage: $0 <room> [time]"
    echo "Available rooms: Paper, Scissors, Keep Away"
    exit 1
fi

grep -r -i "$ROOM" notes/ updates/ | grep -i "${TIME:-''}"
