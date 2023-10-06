FROM ghcr.io/linuxserver/baseimage-kasmvnc:arch

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=SteamOS

RUN \
  echo "**** install vanilla 32 bit packages from multilib ****" && \
  echo '[multilib]' >> /etc/pacman.conf && \
  echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf && \
  pacman -Sy --noconfirm --needed \
    lib32-amdvlk \
    lib32-glibc \
    lib32-libva-intel-driver \
    lib32-libva-mesa-driver \
    lib32-libva-vdpau-driver \
    lib32-libvdpau \
    lib32-mangohud \
    lib32-mesa-utils \
    lib32-mesa-vdpau \
    lib32-vulkan-intel \
    lib32-vulkan-mesa-layers \
    lib32-vulkan-radeon \
    lib32-vulkan-swrast \
    libva-intel-driver \
    libva-utils \
    mesa-vdpau \
    vulkan-swrast && \
  echo "**** add steam repos ****" && \
  echo '[jupiter-staging]' >> /etc/pacman.conf && \
  echo 'Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/os/$arch' >> /etc/pacman.conf && \
  echo 'SigLevel = Never' >> /etc/pacman.conf && \
  echo '[holo-staging]' >> /etc/pacman.conf && \
  echo 'Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/os/$arch' >> /etc/pacman.conf && \
  echo 'SigLevel = Never' >> /etc/pacman.conf && \
  pacman -Syyu --noconfirm && \
  echo "**** install packages ****" && \
  pacman -Sy --noconfirm --needed \
    boost-libs \
    dmidecode \
    dolphin \
    firefox \
    fuse2 \
    gamescope \
    git \
    jq \
    kate \
    konsole \
    lib32-gamescope \
    lib32-libpulse \
    lib32-mesa-vdpau \
    lib32-opencl-mesa \
    lib32-renderdoc-minimal \
    mangohud \
    noto-fonts-cjk \
    plasma-desktop \
    sddm-wayland \
    steamdeck-kde-presets \
    steam-jupiter-stable \
    steamos-customizations \
    unzip \
    xdg-user-dirs \
    xorg-xwayland-jupiter \
    zenity && \
  echo "**** install sunshine ****" && \
  cd /tmp && \
  git clone https://aur.archlinux.org/sunshine.git && \
  chown -R abc:abc sunshine && \
  cd sunshine && \
  sed -i '/npm install/i sudo chown -R 911:1001 \/config' PKGBUILD && \
  sudo -u abc makepkg -sAci --skipinteg --noconfirm --needed && \
  usermod -G input abc && \
  echo "**** steam tweaks ****" && \
  sed -i 's/-steamdeck//g' /usr/bin/steam && \
  echo "**** kde tweaks ****" && \
  sed -i \
    -e 's/applications:org.kde.discover.desktop,/applications:org.kde.konsole.desktop,/g' \
    -e 's#preferred://browser#applications:firefox.desktop#g' \
    /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml && \
  echo "**** cleanup ****" && \
  rm -rf \
    /config/.cache \
    /config/.npm \
    /tmp/* \
    /var/cache/pacman/pkg/* \
    /var/lib/pacman/sync/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
