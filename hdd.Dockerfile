FROM archlinux:latest

# WORKAROUND for glibc 2.33 and old Docker
# See https://github.com/actions/virtual-environments/issues/2658
# Thanks to https://github.com/lxqt/lxqt-panel/pull/1562

COPY glibc-linux4-2.33-4-x86_64.pkg.tar.zst /glibc-linux4-2.33-4-x86_64.pkg.tar.zst
RUN tar -I zstd -xvf /glibc-linux4-2.33-4-x86_64.pkg.tar.zst -C /usr/local
# Install qemu

RUN pacman -Syu qemu --noconfirm;

WORKDIR /data

ENTRYPOINT ["qemu-img", "create", "-f", "raw", "win10_hdd.img"]

CMD [ "32G" ]
