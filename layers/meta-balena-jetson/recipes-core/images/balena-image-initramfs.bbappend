PACKAGE_INSTALL:remove = " mdraid"
PACKAGE_INSTALL:remove = " initramfs-module-recovery"

PACKAGE_INSTALL:append = " mtd-utils fatrw gptfdisk kernel-module-spi-tegra210-quad setup-nv-boot-control"
PACKAGE_INSTALL:append = " \
    tegra-firmware-xusb \
    kernel-module-nvme \
    kernel-module-pcie-tegra194 \
    kernel-module-phy-tegra194-p2u \
    kernel-module-tegra-xudc \
    kernel-module-ucsi-ccg \
    kernel-module-dummy \
    kernel-module-uas \
    kernel-module-tegra-bpmp-thermal \
    kernel-module-pwm-tegra \
    kernel-module-pwm-fan \
    nv-kernel-module-ufs-tegra \
    nv-kernel-module-pcie-tegra264 \
"

IMAGE_ROOTFS_MAXSIZE = "65536"
