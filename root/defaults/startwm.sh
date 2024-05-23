#!/bin/bash

# Set route if defined
if [ ! -z ${HOST_IP+x} ]; then
  sudo ip route delete default
  sudo ip route add ${HOST_IP} dev eth0
  sudo ip route add default via ${HOST_IP}
fi

# Set defaults for KDE
if [ ! -f $HOME/.config/kwinrc ]; then
  kwriteconfig6 --file $HOME/.config/kwinrc --group Compositing --key Enabled false
fi
if [ ! -f $HOME/.config/kscreenlockerrc ]; then
  kwriteconfig6 --file $HOME/.config/kscreenlockerrc --group Daemon --key Autolock false
fi
gio mime x-scheme-handler/https firefox.desktop
gio mime x-scheme-handler/http firefox.desktop
setterm blank 0
setterm powerdown 0

# Copy default files
if [ ! -f $HOME/Desktop/steam-deck.desktop ]; then
  cp \
    /defaults/steam-deck.desktop \
    $HOME/Desktop/steam-deck.desktop
  chmod +x $HOME/Desktop/steam-deck.desktop
fi
if [ ! -d $HOME/.config/sunshine ]; then
  mkdir -p $HOME/.config/sunshine
  cp /defaults/apps.json $HOME/.config/sunshine/
  if [ -z ${DRINODE+x} ]; then
    DRINODE="/dev/dri/renderD128"
  fi
  echo "adapter_name = ${DRINODE}" > $HOME/.config/sunshine/sunshine.conf
fi

# Start sunshine in background
sunshine &

# Runtime deps
mkdir -p $HOME/.XDG
export XDG_RUNTIME_DIR=$HOME/.XDG

# Launch DE depending on env
if [ -z ${RESOLUTION+x} ]; then
  RESOLUTION="1920x1080"
fi
if [ -z ${STARTUP+x} ]; then
  STARTUP="KDE"
fi
export $(dbus-launch)
if [[ "${STARTUP}" == "BIGPICTURE" ]]; then
  sudo sed -i 's/resize=remote/resize=scale/g' /kclient/public/index.html
  # Gamescope is currently broken use a conventional x11 session in openbox
  #gamescope -e -f -b -g -W $(echo ${RESOLUTION}| awk -F'x' '{print $1}') -H $(echo ${RESOLUTION}| awk -F'x' '{print $2}') -r 60 -- steam -bigpicture
  cp /defaults/autostart $HOME/.config/openbox/autostart
  /usr/bin/openbox-session
else
  sudo sed -i 's/resize=scale/resize=remote/g' /kclient/public/index.html
  /usr/bin/startplasma-x11 > /dev/null 2>&1
fi
