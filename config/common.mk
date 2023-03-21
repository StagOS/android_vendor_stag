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

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/lineage/overlay/no-rro
# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    vendor/stag/overlay/common \
    vendor/stag/overlay/no-rro \
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

# SystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed


# Allow the following
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/app/NfcNci/NfcNci.apk \
    system/app/NfcNci/lib/arm64/libnfc_nci_jni.so \
    system/app/PulseMusic/PulseMusic.apk \
    system/app/StagWalls/StagWalls.apk \
    system/bin/clean_cache.sh \
    system/bin/curl \
    system/bin/fsck.ntfs \
    system/bin/mkfs.ntfs \
    system/bin/mount.ntfs \
    system/bin/procmem \
    system/etc/default-permissions/org.pixelexperience.weather.client.xml \
    system/etc/init/stag-init.rc \
    system/etc/init/stag-iosched.rc \
    system/etc/init/stag-ssh.rc \
    system/etc/init/stag-system.rc \
    system/etc/init/stag-updates.rc \
    system/etc/libnfc-nci.conf \
    system/etc/permissions/android.hardware.biometrics.face.xml \
    system/etc/permissions/android.software.nfc.beam.xml \
    system/etc/permissions/org.lineageos.updater.xml \
    system/etc/permissions/org.pixelexperience.weather.client.xml \
    system/etc/permissions/privapp-permissions-camera2.xml \
    system/etc/permissions/privapp-permissions-org.pixelexperience.faceunlock.xml \
    system/etc/permissions/privapp-permissions-snap.xml \
    system/etc/permissions/privapp-permissions-stag.xml \
    system/etc/sensitive_pn.xml \
    system/etc/sysconfig/hiddenapi-whitelist-org.pixelexperience.faceunlock.xml \
    system/etc/sysconfig/stag-power-whitelist.xml \
    system/etc/textclassifier/actions_suggestions.universal.model \
    system/etc/textclassifier/lang_id.model \
    system/etc/textclassifier/textclassifier.en.model \
    system/etc/textclassifier/textclassifier.universal.model \
    system/lib/libRSSupport.so \
    system/lib/libblasV8.so \
    system/lib/librsjni.so \
    system/lib/libsepol.so \
    system/lib64/android.hardware.nfc-V1-ndk.so \
    system/lib64/android.hardware.nfc@1.0.so \
    system/lib64/android.hardware.nfc@1.1.so \
    system/lib64/android.hardware.nfc@1.2.so \
    system/lib64/faceunlock_vendor_dependencies.so \
    system/lib64/libFaceDetectCA.so \
    system/lib64/libMegviiUnlock-jni-1.2.so \
    system/lib64/libMegviiUnlock.so \
    system/lib64/libRSSupport.so \
    system/lib64/libarcsoft-lib.so \
    system/lib64/libarcsoft_faceid.so \
    system/lib64/libarcsoftbase.so \
    system/lib64/libblasV8.so \
    system/lib64/libfuse-lite.so \
    system/lib64/libmegface.so \
    system/lib64/libmpbase.so \
    system/lib64/libnfc-nci.so \
    system/lib64/libnfc_nci_jni.so \
    system/lib64/libntfs-3g.so \
    system/lib64/librsjni.so \
    system/lib64/libsepol.so \
    system/media/bootanimation.zip \
    system/priv-app/FaceUnlockService/FaceUnlockService.apk \
    system/priv-app/TurboAdapter/TurboAdapter.apk \
    system/priv-app/TurboPrebuilt/TurboPrebuilt.apk \
    system/xbin/wget \
    system/app/GoogleExtShared/GoogleExtShared.apk \
    system/app/GooglePrintRecommendationService/GooglePrintRecommendationService.apk \
    system/bin/sqlite3 \
    system/bin/strace \
    system/etc/permissions/privapp-permissions-google.xml \
    system/priv-app/DocumentsUIGoogle/DocumentsUIGoogle.apk \
    system/priv-app/GooglePackageInstaller/GooglePackageInstaller.apk \
    system/priv-app/TagGoogle/TagGoogle.apk \
    system/app/Via/Via.apk \
    system/priv-app/GoogleExtServices/GoogleExtServices.apk

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
$(call inherit-product-if-exists, vendor/gms/products/gms.mk)
ifneq ($(TARGET_MINIFIED_GAPPS),true)
# Setup some Flags, can be disabled in Device tree
TARGET_INCLUDE_STOCK_ARCORE ?= true
TARGET_INCLUDE_LIVE_WALLPAPERS ?= true
TARGET_SUPPORTS_NEXT_GEN_ASSISTANT ?= true
endif
else
ifeq ($(strip $(TARGET_BUILD_LAWNCHAIR)),true)
include vendor/lawnchair/lawnchair.mk
endif
endif

EXTRA_UDFPS_ANIMATIONS ?= false
ifeq ($(EXTRA_UDFPS_ANIMATIONS),true)
PRODUCT_PACKAGES += \
    UdfpsResources
endif

# Quick Tap
ifeq ($(TARGET_SUPPORTS_QUICK_TAP),true)
PRODUCT_COPY_FILES += \
    vendor/stag/prebuilt/common/etc/sysconfig/quick_tap.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/quick_tap.xml
endif
