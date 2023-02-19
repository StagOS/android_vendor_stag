# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

# StagOS Platform Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.stag.build.date=$(BUILD_DATE) \
    ro.stag.device=$(STAG_BUILD) \
    ro.stag.fingerprint=$(ROM_FINGERPRINT) \
    ro.stag.version=$(STAG_VERSION) \
    ro.modversion=$(STAG_VERSION)

# Updater
ifeq ($(IS_OFFICIAL),true)
    ADDITIONAL_SYSTEM_PROPERTIES  += \
        net.stagos.build_type=stag_admin \
        net.stagos.version=$(STAG_VERSION_PROP)
endif
