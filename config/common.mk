# Generic product
PRODUCT_NAME := stag
PRODUCT_BRAND := stag
PRODUCT_DEVICE := generic
EXCLUDE_SYSTEMUI_TESTS := true

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

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    vendor/stag/overlay/common \
    vendor/stag/overlay/themes

# Charging sounds
PRODUCT_COPY_FILES += \
    vendor/stag/sounds/BatteryPlugged.ogg:system/media/audio/ui/BatteryPlugged.ogg \
    vendor/stag/sounds/BatteryPlugged_48k.ogg:system/media/audio/ui/BatteryPlugged_48k.ogg
