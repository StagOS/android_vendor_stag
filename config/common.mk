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

# Copy all Lineage-specific init rc files
$(foreach f,$(wildcard vendor/stag/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):system/etc/init/$(notdir $f)))


# Permissions
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/etc/permissions/privapp-permissions-stag.xml:system/etc/permissions/privapp-permissions-stag.xml

# Changelog
PRODUCT_COPY_FILES += \
    out/../Changelog.mkdn:system/etc/Changelog.txt

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    vendor/stag/overlay/common \
    vendor/stag/overlay/themes \
    vendor/stag/overlay/

# Charging sounds
PRODUCT_COPY_FILES += \
    vendor/stag/sounds/BatteryPlugged.ogg:system/media/audio/ui/BatteryPlugged.ogg \
    vendor/stag/sounds/BatteryPlugged_48k.ogg:system/media/audio/ui/BatteryPlugged_48k.ogg

#Lawnchair permissions and sysconfig
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/etc/permissions/privapp-permissions-lawnchair.xml:system/etc/permissions/privapp-permissions-lawnchair.xml \
    vendor/stag/prebuilt/common/etc/sysconfig/lawnchair-hiddenapi-package-whitelist.xml:system/etc/sysconfig/lawnchair-hiddenapi-package-whitelist.xml

# Weather client
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/etc/permissions/org.pixelexperience.weather.client.xml:system/etc/permissions/org.pixelexperience.weather.client.xml \
    vendor/stag/prebuilt/common/etc/default-permissions/org.pixelexperience.weather.client.xml:system/etc/default-permissions/org.pixelexperience.weather.client.xml

# Copy all Stag-specific init rc files
$(foreach f,$(wildcard vendor/stag/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):system/etc/init/$(notdir $f)))

#Default Browser
PRODUCT_PACKAGES += \
    ViaBrowser

# Proprietary latinime libs needed for Keyboard swyping
ifeq ($(TARGET_ARCH),arm64)
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so \
    vendor/stag/prebuilt/common/lib64/libjni_latinimegoogle.so:system/lib64/libjni_latinimegoogle.so
else
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so \
    vendor/stag/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so
endif

# Cutout control overlays
PRODUCT_PACKAGES += \
    HideCutout \
    StatusBarStock

# WellBeing
PRODUCT_PACKAGES += \
    WellbeingPrebuilt

# Phonograph
PRODUCT_PACKAGES += \
    Phonograph

# APN
PRODUCT_PACKAGES += \
    apns-conf.xml

#IgnoreNeverallows
SELINUX_IGNORE_NEVERALLOWS := true

#Sepolicy
include device/stag/sepolicy/qcom/sepolicy.mk

#StagOs Version
$(call inherit-product, vendor/stag/config/version.mk)
