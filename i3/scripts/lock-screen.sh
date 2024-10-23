#!/bin/bash

tmpbg="$(mktemp /tmp/lock.sh-XXXXXXXXXX.png)"
maim $tmpbg
gm convert $tmpbg -scale 10% -scale 1000% -fill black -colorize 25% $tmpbg

# Pause and unpause dunst. From the manual dunst(1):

# When paused dunst will not display any notifications but keep all notifications
# in a queue.  This can for example be wrapped around a screen locker (i3lock, slock)
# to prevent flickering of notifications through the lock and
# to read all missed notifications after returning to the computer.
killall -SIGUSR1 dunst
i3lock -e -f --nofork -i $tmpbg
killall -SIGUSR2 dunst

rm $tmpbg
