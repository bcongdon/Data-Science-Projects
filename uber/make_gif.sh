#!/usr/bin/env bash

convert -delay 20 -loop 0 hour-*.jpg uncompressed.gif
gifsicle --resize-fit-height 300 -i uncompressed.gif --colors 256 > compressed.gif