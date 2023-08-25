#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

xrandr --output Virtual1 --mode 1920x1080
run sxhkd
