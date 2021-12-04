# ezkernel
It just builds a kernel.

```
$ make build
```

How to get a microvm up and running with this project.
```
$ make build
$ mkdir -p initramfs-src/bin
$ curl -Lo initramfs-src/bin/busybox https://www.busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64
$ echo '#!/bin/busybox sh' > initramfs-src/init
$ echo '/bin/busybox sh' >> initramfs-src/init
$ chmod +x initramfs-src/bin/busybox initramfs-src/init
$ cd initramfs-src && find . | cpio -o -H newc | gzip > ../initramfs && cd -
$ qemu-system-x86_64 \
    -M microvm,x-option-roms=off,isa-serial=off \
    -no-acpi -no-user-config -no-reboot \
    -smp 2 -m 2048 \
    -kernel bzImage -initrd initramfs \
    -device virtio-serial-device -chardev stdio,id=virtiocon0 -device virtconsole,chardev=virtiocon0 \
    -netdev "user,id=net0,${PORTS}" \
    -device virtio-net-device,netdev=net0 \
    -append "console=hvc0 ip=dhcp nameserver=8.8.8.8 nameserver=8.8.4.4 init=/init" \
    -display none
```

At this point, you should have a root console open in your terminal. Installing busybox is done like so.
```
# mkdir -p /bin /sbin /usr/sbin /usr/bin
# /bin/busybox --install -s
```

Mounts are done like this.
```
# mkdir -p /proc /dev /sys /tmp /run
# mount -t proc      proc      /proc
# mount -t proc      proc      /dev
# mount -t sysfs     sysfs     /sys
# mount -t tmpfs     tmpfs     /tmp
# mount -t tmpfs     tmpfs     /run

# mkdir -p /dev/pts /dev/mqueue
# mount -t devpts    devpts    /dev/pts
# mount -t mqueue    mqueue    /dev/mqueue
# mount -t cgroup    cgroup    /sys/fs/cgroup
```

Anything you can setup at this point manually can be don with the init file that
was made in `initramfs-src/init`. Look into things like `switch_root`, perhaps
check out [alpine's init script](https://github.com/alpinelinux/mkinitfs/blob/240cdd3518e489420af719935445df0cf87e77c7/initramfs-init.in).
It uses busybox as well.

\- glhf

## Why?
Just needed a kernel that works with qemu for microvms that supported mounting a
9p file system at root.

## Todo
* Build the latest kernel. Dockerfiles are hard coded to build 5.15.
* Add a file with kernel version at /version.txt
