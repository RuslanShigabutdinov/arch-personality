#!/bin/bash
# Toggle wofi: close it if running, otherwise open it.
# Escape closes wofi by itself, so there is no state to clean up.

pkill -x wofi || exec wofi
