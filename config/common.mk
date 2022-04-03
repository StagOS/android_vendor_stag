# Generic product
PRODUCT_NAME := stag
PRODUCT_BRAND := stag
PRODUCT_DEVICE := generic

# version
include vendor/stag/config/version.mk

# Props
include vendor/stag/config/props.mk

# Packages
include vendor/stag/config/packages.mk

# Sounds
include vendor/stag/config/sounds.mk

# Bootanimation
TARGET_SCREEN_WIDTH ?= 1080
TARGET_SCREEN_HEIGHT ?= 1920
TARGET_SCREEN_RES ?= 1080
ifeq ($(TARGET_SCREEN_RES), 720)
	PRODUCT_COPY_FILES += vendor/stag/prebuilt/common/bootanimation/720p.zip:system/media/bootanimation.zip
else ifeq ($(TARGET_SCREEN_RES), 1080)
	PRODUCT_COPY_FILES += vendor/stag/prebuilt/common/bootanimation/1080p.zip:system/media/bootanimation.zip
endif

# PixelPropsUtils
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/etc/pixel_2016_exclusive.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_2016_exclusive.xml

# Signapk/Brotli
PRODUCT_HOST_PACKAGES += \
    signapk \
    brotli

# Extra packages
PRODUCT_PACKAGES += \
    libjni_latinimegoogle

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    vendor/stag/overlay/common \
    vendor/stag/overlay

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += \
    vendor/stag/overlay/common \
    vendor/stag/overlay/lawnchair

# Copy all custom init rc files
$(foreach f,$(wildcard vendor/stag/prebuilt/common/etc/init/*.rc),\
    $(eval PRODUCT_COPY_FILES += $(f):system/etc/init/$(notdir $f)))

# Changelog
#PRODUCT_COPY_FILES += \
#    out/../Changelog.mkdn:system/etc/Changelog.txt

#IgnoreNeverallows
ifeq ($(TARGET_BUILD_VARIANT),user)
	SELINUX_IGNORE_NEVERALLOWS := false
else
        SELINUX_IGNORE_NEVERALLOWS := true
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/stag/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/stag/prebuilt/common/bin/50-stag.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-stag.sh \

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/stag/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/stag/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/etc/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/etc/permissions/stag-power-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/stag-power-whitelist.xml

# Weather client
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/etc/permissions/org.pixelexperience.weather.client.xml:system/etc/permissions/org.pixelexperience.weather.client.xml \
    vendor/stag/prebuilt/common/etc/default-permissions/org.pixelexperience.weather.client.xml:system/etc/default-permissions/org.pixelexperience.weather.client.xml

# Google Assistant
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.opa.eligible_device=true

# Camera Permissions
PRODUCT_COPY_FILES += \
   vendor/stag/prebuilt/common/etc/permissions/privapp-permissions-snap.xml:system/etc/permissions/privapp-permissions-snap.xml \
   vendor/stag/prebuilt/common/etc/permissions/privapp-permissions-camera2.xml:system/etc/permissions/privapp-permissions-camera2.xml

# Stag Perms
PRODUCT_COPY_FILES += \
   vendor/stag/prebuilt/common/etc/permissions/privapp-permissions-stag-system.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-stag.xml \
   vendor/stag/prebuilt/common/etc/permissions/privapp-permissions-stag-system_ext.xml:system_ext/etc/permissions/privapp-permissions-stag.xml \
   vendor/stag/prebuilt/common/etc/permissions/privapp-permissions-stag-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-stag.xml \

# Clean up packages cache to avoid wrong strings and resources
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/bin/clean_cache.sh:system/bin/clean_cache.sh

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# APN
PRODUCT_PACKAGES += \
    apns-conf.xml

# Sensitive Phone Numbers list
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/etc/sensitive_pn.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sensitive_pn.xml

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Enable gestural navigation overlay to match default navigation mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    NexusLauncherRelease

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= true
ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    FaceUnlockService
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face_unlock_service.enabled=$(TARGET_FACE_UNLOCK_SUPPORTED)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# TARGET_BUILD_LAWNCHAIR ?= true

# TextClassifier
PRODUCT_PACKAGES += \
	libtextclassifier_annotator_en_model \
	libtextclassifier_annotator_universal_model \
	libtextclassifier_actions_suggestions_universal_model \
	libtextclassifier_lang_id_model

# GApps
ifeq ($(WITH_GAPPS),true)
# RRO Overlays
#$(call inherit-product, vendor/stag/config/rro_overlays.mk)

include vendor/gapps/config.mk
else
ifeq ($(strip $(TARGET_BUILD_LAWNCHAIR)),true)
include vendor/lawnchair/lawnchair.mk
endif
endif

ifeq ($(TARGET_USES_CARRIERSETTINGS),true)
# CarrierSettings
$(call inherit-product, vendor/stag/CarrierSettings/config.mk)
endif

EXTRA_UDFPS_ANIMATIONS ?= false
ifeq ($(EXTRA_UDFPS_ANIMATIONS),true)
PRODUCT_PACKAGES += \
    UdfpsResources
endif

