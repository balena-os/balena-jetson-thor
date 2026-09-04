IMAGE_FSTYPES += "balenaos-img"

do_rootfs:balenaos-img[depends] += " tegra-flash-dry:do_install nvidia-kernel-oot:do_deploy edk2-firmware-tegra:do_deploy "
DTBFILE ?= "${@os.path.basename(d.getVar('KERNEL_DEVICETREE', True).split()[0])}"

do_resin_boot_dirgen_and_deploy[depends] += "l4t-launcher-extlinux:do_install edk2-firmware-tegra:do_deploy"

IMAGE_INSTALL:append = " \
    tegra-bluetooth \
    tegra-wifi \
    l4t-launcher-extlinux \
    setup-nv-boot-control \
    jetson-dtbs \
    uefi-capsule-container \
    jetson-qspi-manager \
    nvidia-kernel-oot-dtb \
"

# We don't mount or use the esp partition, so let's
# remove the systemd mounts that delay booting
IMAGE_INSTALL:remove = "setup-nv-boot-control-service"
MACHINE_EXTRA_RRECOMMENDS += " kernel-image-initramfs"
MACHINE_EXTRA_RDEPENDS += " kernel-image-initramfs"
IMAGE_INSTALL:remove = "kernel-image-image"

