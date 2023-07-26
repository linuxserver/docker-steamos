FROM lsiodev/kasmvnc-base:arch-c4215973-pkg-c4215973-dev-d1ed79ccc7d1225acad0a6c9870904a8da3ad960

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

RUN \
  echo "**** add steam repos ****" && \
  echo '[jupiter-staging]' >> /etc/pacman.conf && \
  echo 'Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/os/$arch' >> /etc/pacman.conf && \
  echo 'SigLevel = Never' >> /etc/pacman.conf && \
  echo '[holo-staging]' >> /etc/pacman.conf && \
  echo 'Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/os/$arch' >> /etc/pacman.conf && \
  echo 'SigLevel = Never' >> /etc/pacman.conf && \
  echo '[multilib]' >> /etc/pacman.conf && \
  echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf && \
  pacman -Syyu --noconfirm && \
  echo "**** install packages ****" && \
  pacman -Sy --noconfirm --needed \
    dmidecode \
    dolphin \
    firefox \
    gamescope \
    kate \
    konsole \
    lib32-amdvlk \
    lib32-glibc \
    lib32-mangohud \
    lib32-vulkan-radeon \
    mangohud \
    mesa \
    plasma-desktop \
    sddm-wayland \
    steamdeck-kde-presets \
    steam-jupiter-stable \
    steamos-customizations \
    vulkan-swrast \
    xorg-xwayland-jupiter && \
  echo "**** kde tweaks ****" && \
  sed -i \
    -e 's/applications:org.kde.discover.desktop,/applications:org.kde.konsole.desktop,/g' \
    -e 's#preferred://browser#applications:firefox.desktop#g' \
    /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml && \
  echo "**** steam tweaks ****" && \
  find / -name "steam.desktop" -exec sed -i 's/^Exec=/Exec=dbus-launch /g' {} \; && \
  find / -name "systemsettings.desktop" -exec sed -i 's/^Exec=/Exec=dbus-launch /g' {} \; && \
  echo "**** cleanup ****" && \
  rm -rf \
    /config/.cache \
    /tmp/* \
    /var/cache/pacman/pkg/* \
    /var/lib/pacman/sync/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
