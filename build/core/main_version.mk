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

# Build fingerprint
BUILD_NUMBER_CUSTOM := $(shell date -u +%H%M)
ifneq ($(filter OFFICIAL,$(STAG_BUILD_TYPE)),)
BUILD_SIGNATURE_KEYS := release-keys
else
BUILD_SIGNATURE_KEYS := test-keys
endif
BUILD_FINGERPRINT := $(PRODUCT_BRAND)/$(TARGET_DEVICE)/$(TARGET_DEVICE):$(PLATFORM_VERSION)/$(BUILD_ID)/$(BUILD_NUMBER_CUSTOM):$(TARGET_BUILD_VARIANT)/$(BUILD_SIGNATURE_KEYS)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
