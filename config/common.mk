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

# Changelog
PRODUCT_COPY_FILES += \
    out/../Changelog.mkdn:system/etc/Changelog.txt

#IgnoreNeverallows
SELINUX_IGNORE_NEVERALLOWS := true

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/stag/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/stag/prebuilt/common/bin/50-stag.sh:system/addon.d/50-stag.sh \
    vendor/stag/prebuilt/common/bin/blacklist:system/addon.d/blacklist

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/stag/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/stag/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif
