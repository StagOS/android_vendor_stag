ifeq ($(STAG_BUILD_TYPE),$(filter $(STAG_BUILD_TYPE),BETA TEST OFFICIAL))

STAG_OTA_VERSION_CODE := 14.0

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.stag.ota.version_code=$(STAG_OTA_VERSION_CODE) \
    stag.updater.allow_downgrading=true

ifeq ($(STAG_ENABLE_TEST_OTA), true)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.stag.ota.test_mode=true

endif

PRODUCT_PACKAGES += \
   OpenDelta

PRODUCT_COPY_FILES += \
    vendor/stag/config/permissions/eu.chainfire.opendelta.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/eu.chainfire.opendelta.xml

endif
