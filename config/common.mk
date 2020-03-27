# Generic product
PRODUCT_NAME := stag
PRODUCT_BRAND := stag
PRODUCT_DEVICE := generic
EXCLUDE_SYSTEMUI_TESTS := true

# version
include vendor/stag/config/version.mk

# Props
include vendor/stag/config/props.mk

# Packages
include vendor/stag/config/packages.mk

# Bootanimation
ifeq ($(TARGET_SCREEN_RES), 720)
	PRODUCT_COPY_FILES += vendor/stag/prebuilt/common/bootanimation/720p.zip:system/media/bootanimation.zip
else ifeq ($(TARGET_SCREEN_RES), 1080)
	PRODUCT_COPY_FILES += vendor/stag/prebuilt/common/bootanimation/1080p.zip:system/media/bootanimation.zip
else
	PRODUCT_COPY_FILES += vendor/stag/prebuilt/common/bootanimation/1080p.zip:system/media/bootanimation.zip
endif

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
    vendor/stag/prebuilt/common/bin/50-stag.sh:system/addon.d/50-stag.sh \

ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/stag/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/stag/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
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
   vendor/stag/prebuilt/common/etc/permissions/privapp-permissions-stag-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-stag.xml \

# Lawnchair
ifeq ($(TARGET_INCLUDE_LAWNCHAIR),true)
PRODUCT_PACKAGE_OVERLAYS += vendor/stag/overlay/lawnchair

PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/etc/permissions/privapp-permissions-lawnchair.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-lawnchair.xml \
    vendor/stag/prebuilt/common/etc/permissions/lawnchair-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/lawnchair-hiddenapi-package-whitelist.xml
endif

# Clean up packages cache to avoid wrong strings and resources
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/bin/clean_cache.sh:system/bin/clean_cache.sh

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# APN
PRODUCT_PACKAGES += \
    apns-conf.xml

ifneq ($(TARGET_USES_PREBUILT_CAMERA_SERVICE), true)
PRODUCT_SOONG_NAMESPACES += \
    frameworks/av/camera/cameraserver \
    frameworks/av/services/camera/libcameraservice
endif

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI

ifeq ($(EXTRA_FOD_ANIMATIONS),true)
DEVICE_PACKAGE_OVERLAYS += vendor/stag/overlay/fod
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/stag/overlay/fod
endif

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED := false
ifneq ($(TARGET_DISABLE_ALTERNATIVE_FACE_UNLOCK), true)
PRODUCT_PACKAGES += \
    FaceUnlockService
TARGET_FACE_UNLOCK_SUPPORTED := true
endif
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face.moto_unlock_service=$(TARGET_FACE_UNLOCK_SUPPORTED)

# GApps
ifeq ($(WITH_GAPPS),true)
include vendor/pixelgapps/pixel-gapps.mk
endif
