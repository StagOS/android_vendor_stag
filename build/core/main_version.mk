# StagOS System Version
ADDITIONAL_BUILD_PROPERTIES += \
    ro.stag.version=$(STAG_VERSION) \
    ro.stag.releasetype=$(STAG_BUILD_TYPE) \
    ro.stag.build.version=$(StagOS_VERSION).$(StagOS_VERSION_MIN) \
    ro.modversion=$(STAG_VERSION) \

# StagOS Platform Display Version
ADDITIONAL_BUILD_PROPERTIES += \
    ro.stag.display.version=$(STAG_DISPLAY_VERSION)

# StagOS Platform SDK Version
ADDITIONAL_BUILD_PROPERTIES += \
    ro.stag.build.version.plat.sdk=$(STAG_PLATFORM_SDK_VERSION)

# StagOS Platform Internal Version
ADDITIONAL_BUILD_PROPERTIES += \
    ro.stag.build.version.plat.rev=$(STAG_PLATFORM_REV)
