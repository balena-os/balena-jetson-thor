# Deltas on meta-tegra's nvidia-container-toolkit recipe, which conf/layer.conf
# makes visible. See docs/toolkit.md.

# balenaOS ships balena-engine, not upstream docker, so meta-tegra's `docker`
# runtime dep is unsatisfiable here and blocks IMAGE_INSTALL from resolving.
RDEPENDS:${PN}:remove = "docker"

# The version follows the device repo's meta-tegra pin, so a bump could walk us
# backwards onto a vulnerable nvidia-container-cli. See docs/toolkit.md#cve-floor.
NVRUNTIME_TOOLKIT_MIN_VERSION = "1.17.8"

python () {
    pv = d.getVar('PV')
    floor = d.getVar('NVRUNTIME_TOOLKIT_MIN_VERSION')
    if bb.utils.vercmp_string(pv, floor) < 0:
        bb.fatal(
            "nvidia-container-toolkit %s is below the %s CVE floor "
            "(CVE-2024-0132, CVE-2025-23359, CVE-2025-23266/23267 all affect the "
            "nvidia-container-cli path this extension's --runtime=nvidia route "
            "uses). The version comes from the device repo's meta-tegra pin - "
            "move meta-tegra forward rather than lowering this floor."
            % (pv, floor))
}

do_configure:prepend() {
    # 1. Lower Go requirement in go.mod files
    find ${S} -name "go.mod" -exec sed -i 's/^go 1\.25.*/go 1.24.6/' {} +

    # 2. Fix specDirAsRoot.Chmod in spec.go
    sed -i 's/specDirAsRoot\.Chmod(filename, s\.permissions)/os.Chmod(filepath.Join(specDir, filename), s.permissions)/g' \
        ${S}/src/github.com/NVIDIA/nvidia-container-toolkit/pkg/nvcdi/spec/spec.go

    # 3. Fix containerRoot.MkdirAll in params_linux.go
    sed -i 's/containerRoot\.MkdirAll(hookScratchDirPath\[1:\], 0755)/os.MkdirAll(filepath.Join(containerRootDirPath, hookScratchDirPath[1:]), 0755)/g' \
        ${S}/src/github.com/NVIDIA/nvidia-container-toolkit/cmd/nvidia-cdi-hook/disable-device-node-modification/params_linux.go

    # 4. Fix containerRoot.MkdirAll and newroot.MkdirAll in ldconfig_linux.go
    sed -i -E 's/(containerRoot|newroot)\.MkdirAll\(([^,]+),\s*([^)]+)\)/os.MkdirAll(filepath.Join(\1.Name(), \2), \3)/g' \
        ${S}/src/github.com/NVIDIA/nvidia-container-toolkit/internal/ldconfig/ldconfig_linux.go
}
