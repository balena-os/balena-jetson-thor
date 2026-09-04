include balena-image.inc

do_image_balenaos_img[depends] += " tegra-flash-dry:do_deploy l4t-launcher-extlinux:do_install edk2-firmware-tegra:do_deploy tegra-espimage:do_image_complete "

# All values are in KiB
# In Ubuntu the APP partition starts at 2795552
# however that value is not aligned to 4096,
# so we use the next closer value
DEVICE_SPECIFIC_SPACE:jetson-agx-thor-devkit = "2797568"
BALENA_BOOT_SIZE:jetson-agx-thor-devkit = "97280"
IMAGE_ROOTFS_SIZE:jetson-agx-thor-devkit = "1966080"

DEPENDS:append = " tegra-espimage "

BALENA_BOOT_PARTITION_FILES:append = " \
    extra_uEnv.txt:/extra_uEnv.txt \
"

IMAGE_INSTALL:append = " \
    kernel-image-initramfs \
    tegra-redundant-boot \
    tegra-nv-boot-control-config \
    tegra-eeprom-tool \
    tegra-nvfancontrol \
    tegra-nvpower \
    gptfdisk \
    tegra-nvpmodel \
    tegra-configs-udev \
    dtc \
    pciutils \
    tegra-tools-tegrastats tegra-tools-jetson-clocks \
    nvidia-kernel-oot-display nvidia-kernel-oot-cameras nvidia-kernel-oot-bluetooth nvidia-kernel-oot-wifi \
    nvidia-kernel-oot-canbus nvidia-kernel-oot-virtualization nvidia-kernel-oot-base nvidia-drm-loadconf \
    kernel-module-r8126 kernel-module-rtl8852ce linux-noble-nvidia-tegra-extlinux tegra-firmware-tegra264 tegra-firmware-rtl8852 tegra-firmware-vic kernel-module-pcie-tegra264 kernel-module-tegra264-mc-hwpm \
    kernel-module-pwm-fan kernel-module-pwm-tegra kernel-module-tegra-bpmp-thermal nvidia-kernel-oot-compute l4t-launcher \
"


PART_SPEC_FILE:jetson-agx-thor-devkit = "partition_specification234_agx_thor.txt"

check_size() {
    file_path=${1}
    [ -f "${file_path}" ] || bbfatal "Specified path does not exist: ${file_path}"
    file_size=$(ls -l ${file_path} | awk '{print $5}')
    part_size=${2}

    if [ "$file_size" -ge "$part_size" ]; then
        bbfatal "File ${file_path} too big for raw partition!"
    fi;
}

device_specific_configuration() {
    partitions=$(cat "${DEPLOY_DIR_IMAGE}/tegra-binaries/${PART_SPEC_FILE}")
    echo "device_specific_configuration: Partitions list: ${partitions}"
    START=40
    for n in ${partitions}; do
        part_name=$(echo $n | cut -d ':' -f 1)
        file_name=$(echo $n | cut -d ':' -f 2)
        part_size=$(echo $n | cut -d ':' -f 3)
        END=$(expr ${START} \+ ${part_size} \- 1)
        echo "device_specific_configuration: file: ${file_name}, part: ${part_name}, start: ${START} - size: ${part_size} end: ${END}"
        parted -s ${BALENA_RAW_IMG} unit s mkpart $part_name ${START} ${END}
        if [ ! "$file_name" = "none.bin" ]; then
            file_path=$(find ${DEPLOY_DIR_IMAGE}/ -name $file_name)
            check_size ${file_path} $(expr ${part_size} \* 512)
            dd if=$file_path of=${BALENA_RAW_IMG} conv=notrunc seek=${START} bs=512
        else
            dd if=/dev/zero of=${BALENA_RAW_IMG} conv=notrunc seek=${START} bs=512 count=${part_size}
      fi
      START=$(expr ${END} \+ 1)
    done
}

