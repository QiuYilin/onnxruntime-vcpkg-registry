# On Windows, we can get a cpuinfo.dll, but it exports no symbols.
if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO luncliff/cpuinfo
    REF b23b0d3bbc441ac1172458827ef309e9f6c47fd4
    SHA512 ea31b46a0375f67de00241aeec48678a476e8979f6ad0943bebee3c46c848f62ae8d282c9ac8625014f77af5a6dbbb9adf9e98d78111dad0cdc95b40f36520ce
    HEAD_REF master
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools CPUINFO_BUILD_TOOLS
)

# CPUINFO_TARGET_PROCESSOR
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS_DEBUG
        -DCPUINFO_BUILD_TOOLS=OFF
        -DCPUINFO_LOG_LEVEL=debug
    OPTIONS_RELEASE
        ${FEATURE_OPTIONS}
        -DCPUINFO_LOG_LEVEL=default
    OPTIONS
        -DCPUINFO_RUNTIME_TYPE=${VCPKG_CRT_LINKAGE}
        -DCPUINFO_BUILD_UNIT_TESTS=OFF
        -DCPUINFO_BUILD_MOCK_TESTS=OFF
        -DCPUINFO_BUILD_BENCHMARKS=OFF
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "share/${PORT}")
vcpkg_fixup_pkgconfig() # pkg_check_modules(libcpuinfo)

if("tools" IN_LIST FEATURES)
    vcpkg_copy_tools(
        TOOL_NAMES cache-info cpuid-dump cpu-info isa-info
        AUTO_CLEAN
    )
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE"
     DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright
)
