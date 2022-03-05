ifeq ($(STAG_BUILD_TYPE),$(filter $(STAG_BUILD_TYPE),TEST OFFICIAL))

STAG_OTA_VERSION_CODE := 12.0

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.stag.ota.version_code=$(STAG_OTA_VERSION_CODE) \
#    stag.updater.allow_downgrading=true

PRODUCT_PACKAGES += \
    Updater

PRODUCT_COPY_FILES += \
    vendor/stag/config/permissions/org.lineageos.updater.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/org.lineageos.updater.xml

endif
