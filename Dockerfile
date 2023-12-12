FROM archlinux:latest

# WORKAROUND for glibc 2.33 and old Docker
# See https://github.com/actions/virtual-environments/issues/2658
# Thanks to https://github.com/lxqt/lxqt-panel/pull/1562

COPY glibc-linux4-2.33-4-x86_64.pkg.tar.zst /glibc-linux4-2.33-4-x86_64.pkg.tar.zst
RUN tar -I zstd -xvf /glibc-linux4-2.33-4-x86_64.pkg.tar.zst -C /usr/local

RUN tee -a /etc/pacman.conf <<< '[community-testing]'; \
    tee -a /etc/pacman.conf <<< 'Include = /etc/pacman.d/mirrorlist'; \
    #
    # install packages
    pacman -Syu sudo git make automake gcc python go autoconf cmake pkgconf alsa-utils fakeroot \
    tigervnc xterm xorg-xhost xdotool ufw --noconfirm; \
    #
    # add user
    useradd arch; \
    echo 'arch ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers; \
    mkdir /home/arch; \
    chown arch:arch /home/arch;


COPY glibc-linux4-2.33-4-x86_64.pkg.tar.zst /glibc-linux4-2.33-4-x86_64.pkg.tar.zst
RUN tar -I zstd -xvf /glibc-linux4-2.33-4-x86_64.pkg.tar.zst -C /usr/local

WORKDIR /home/arch/yay

RUN git clone https://aur.archlinux.org/yay.git .;
RUN pacman -S --needed --noconfirm sudo # Install sudo
RUN useradd builduser -m # Create the builduser
RUN passwd -d builduser # Delete the buildusers password
RUN printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers # Allow the builduser passwordless sudo
RUN chown -R builduser:builduser /home/arch/yay # Give ownership to builduser

RUN sudo -u builduser makepkg -si --noconfirm;

#install tigervnc-viewer
RUN yay -S tigervnc --noconfirm;

RUN pacman -Syu qemu libvirt dnsmasq virt-manager bridge-utils flex bison edk2-ovmf \
    netctl libvirt-dbus libguestfs --noconfirm;

WORKDIR /home/arch
RUN echo "Download virtio-win.iso(600MB)"
ARG DOWNLOAD_URL="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio"
RUN FILE_NAME="$(curl -s -N -L "$DOWNLOAD_URL" | grep -Po -m 1 '(?<=\")(?=(virtio-win-)).*?(?<=.iso)')"; \
    echo "Downloading $DOWNLOAD_URL/$FILE_NAME"; \
    curl -sSL -o virtio-win.iso "$DOWNLOAD_URL/$FILE_NAME";

ENV DISPLAY :0
ENV USER arch

COPY boot.sh boot.sh
ENTRYPOINT ./boot.sh
