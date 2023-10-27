#!/usr/bin/env bash
# grim -g "$(slurp)" - | convert - -shave 1x1 PNG:- | swappy -f -
grim -g "$(slurp)" - | swappy -f -
