# Generic product
PRODUCT_NAME := stag
PRODUCT_BRAND := stag
PRODUCT_DEVICE := generic
EXCLUDE_SYSTEMUI_TESTS := true

# Bootanimation
ifeq ($(TARGET_SCREEN_RES), 720)
	PRODUCT_COPY_FILES += vendor/stag/prebuilt/common/bootanimation/720p.zip:system/media/bootanimation.zip
else ifeq ($(TARGET_SCREEN_RES), 1080)
	PRODUCT_COPY_FILES += vendor/stag/prebuilt/common/bootanimation/1080p.zip:system/media/bootanimation.zip
else
	PRODUCT_COPY_FILES += vendor/stag/prebuilt/common/bootanimation/1080p.zip:system/media/bootanimation.zip
endif

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
    vendor/stag/overlay/themes \
    vendor/stag/overlay/

# Charging sounds
PRODUCT_COPY_FILES += \
    vendor/stag/sounds/BatteryPlugged.ogg:system/media/audio/ui/BatteryPlugged.ogg \
    vendor/stag/sounds/BatteryPlugged_48k.ogg:system/media/audio/ui/BatteryPlugged_48k.ogg

#Default Launcher
PRODUCT_PACKAGES += \
    Launcher3

# Weather client
PRODUCT_COPY_FILES += \
    vendor/stag/etc/permissions/org.pixelexperience.weather.client.xml:system/etc/permissions/org.pixelexperience.weather.client.xml \
    vendor/stag/etc/default-permissions/org.pixelexperience.weather.client.xml:system/etc/default-permissions/org.pixelexperience.weather.client.xml

#Default Browser
PRODUCT_PACKAGES += \
    ViaBrowser

# WellBeing
PRODUCT_PACKAGES += \
    WellbeingPrebuilt

# Phonograph
PRODUCT_PACKAGES += \
    Phonograph

# Fix Google dialer
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/etc/dialer_experience.xml:system/etc/sysconfig/dialer_experience.xml \
    vendor/stag/prebuilt/common/etc/permissions/com.google.android.dialer.support.xml:system/etc/permissions/com.google.android.dialer.support.xml \
    vendor/stag/prebuilt/common/framework/com.google.android.dialer.support.jar:system/framework/com.google.android.dialer.support.jar

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/potato/config/BoardConfigQcom.mk
endif
