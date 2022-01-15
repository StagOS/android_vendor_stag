# StagOS System Version
ADDITIONAL_SYSTEM_PROPERTIES += \
#    ro.stag.version=$(STAG_VERSION) \
    ro.stag.releasetype=$(STAG_BUILD_TYPE) \
#    ro.stag.build.version=$(StagOS_VERSION).$(StagOS_BUILD) \
    ro.modversion=$(STAG_VERSION) \

# StagOS Platform Display Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.stag.display.version=$(STAG_DISPLAY_VERSION)

# StagOS Platform SDK Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.stag.build.version.plat.sdk=$(STAG_PLATFORM_SDK_VERSION)

# StagOS Platform Internal Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.stag.build.version.plat.rev=$(STAG_PLATFORM_REV)

# Build fingerprint
ifeq ($(BUILD_FINGERPRINT),)
BUILD_NUMBER_CUSTOM := $(shell date -u +%H%M)
ifneq ($(filter OFFICIAL,$(STAG_BUILD_TYPE)),)
CUSTOM_DEVICE ?= $(TARGET_DEVICE)
BUILD_SIGNATURE_KEYS := release-keys
else
BUILD_SIGNATURE_KEYS := test-keys
endif
BUILD_FINGERPRINT := $(PRODUCT_BRAND)/$(CUSTOM_DEVICE)/$(CUSTOM_DEVICE):$(PLATFORM_VERSION)/$(BUILD_ID)/$(BUILD_NUMBER_CUSTOM):$(TARGET_BUILD_VARIANT)/$(BUILD_SIGNATURE_KEYS)
endif
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
