#!/bin/bash

# Set route if defined
if [ ! -z ${HOST_IP+x} ]; then
  sudo ip route delete default
  sudo ip route add ${HOST_IP} dev eth0
  sudo ip route add default via ${HOST_IP}
fi

# Set defaults for KDE
if [ ! -f $HOME/.config/kwinrc ]; then
  kwriteconfig5 --file $HOME/.config/kwinrc --group Compositing --key Enabled false
fi
if [ ! -f $HOME/.config/kscreenlockerrc ]; then
  kwriteconfig5 --file $HOME/.config/kscreenlockerrc --group Daemon --key Autolock false
fi
setterm blank 0
setterm powerdown 0

# Copy default files
if [ ! -f $HOME/Desktop/steam-desktop.desktop ]; then
  cp \
    /defaults/steam-desktop.desktop \
    $HOME/Desktop/steam-desktop.desktop
  chmod +x $HOME/Desktop/steam-desktop.desktop
fi

# Runtime deps
mkdir -p $HOME/.XDG
export XDG_RUNTIME_DIR=$HOME/.XDG

# Launch DE
export $(dbus-launch)
/usr/bin/startplasma-x11 > /dev/null 2>&1
