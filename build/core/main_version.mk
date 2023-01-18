# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

# StagOS Platform Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.stag.build.date=$(BUILD_DATE) \
    ro.stag.fingerprint=$(ROM_FINGERPRINT) \
    ro.stag.version=$(STAG_VERSION) \
    ro.stag.device=$(STAG_BUILD) \
    ro.modversion=$(STAG_VERSION)

# Updater
ifeq ($(IS_OFFICIAL),true)
    ADDITIONAL_SYSTEM_PROPERTIES  += \
        ro.is_official=true
endif
