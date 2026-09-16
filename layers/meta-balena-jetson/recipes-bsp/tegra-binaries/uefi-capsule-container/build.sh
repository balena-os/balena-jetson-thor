#!/bin/bash

set -e

bl_spec="t26x_agx_bl_spec"
pushd /build_dir/Linux_for_Tegra/

ToT_BSP=$(pwd)

dtc -I dtb -O dts ./kernel/dtb/L4TConfiguration.dtbo -o ./kernel/dtb/L4TConfiguration.dts && \
    sed -i '/RootfsRetryCountMax[[:space:]]*{/,/};/ { s/data = <0x3/data = <0x9/; s/locked;/non-volatile;/ }' ./kernel/dtb/L4TConfiguration.dts && \
    dtc -I dts -O dtb ./kernel/dtb/L4TConfiguration.dts -o ./kernel/dtb/L4TConfiguration.dtbo


sudo ./l4t_generate_soc_bup.sh -e ${bl_spec} t26x
sudo ./generate_capsule/l4t_generate_soc_capsule.sh -i bootloader/payloads_t26x/bl_only_payload -o ./TEGRA_BL.Cap t264

exit 0
