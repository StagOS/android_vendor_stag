# Copyright (C) 2017 Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH := $(call my-dir)

# Lawnchair
include $(CLEAR_VARS)
LOCAL_MODULE := Lawnchair
LOCAL_SRC_FILES := priv-app/Lawnchair.apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_CLASS := APPS
LOCAL_PRIVILEGED_MODULE := true
LOCAL_OVERRIDES_PACKAGES := Launcher2 Launcher3 Launcher3QuickStep NexusLauncherPrebuilt
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_DEX_PREOPT := false
include $(BUILD_PREBUILT)

#ViaBrowser
include $(CLEAR_VARS)
LOCAL_MODULE := ViaBrowser
LOCAL_SRC_FILES := app/$(LOCAL_MODULE).apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_DEX_PREOPT := false
include $(BUILD_PREBUILT)

# Turbo
include $(CLEAR_VARS)
LOCAL_MODULE := Turbo
LOCAL_SRC_FILES := app/Turbo.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_CERTIFICATE := platform
LOCAL_PRIVILEGED_MODULE := true
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_DEX_PREOPT := false
include $(BUILD_PREBUILT)

# StagWalls
include $(CLEAR_VARS)
LOCAL_MODULE := StagWalls
LOCAL_SRC_FILES := app/StagWalls.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_CERTIFICATE := platform
LOCAL_PRIVILEGED_MODULE := true
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_DEX_PREOPT := false
include $(BUILD_PREBUILT)


# Digital WellBeing
include $(CLEAR_VARS)
LOCAL_MODULE := WellbeingPrebuilt
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := priv-app/$(LOCAL_MODULE).apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_CLASS := APPS
LOCAL_PRIVILEGED_MODULE := true
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_DEX_PREOPT := false
include $(BUILD_PREBUILT)

# Substratum Signature
include $(CLEAR_VARS)
LOCAL_MODULE := SubstratumKey
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := priv-app/$(LOCAL_MODULE).apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_PRIVILEGED_MODULE := true
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := .apk
LOCAL_DEX_PREOPT := false
include $(BUILD_PREBUILT)

# Sysconfig for turbo
include $(CLEAR_VARS)
LOCAL_MODULE := turbo.xml
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/sysconfig
LOCAL_SRC_FILES := etc/sysconfig/turbo.xml
include $(BUILD_PREBUILT)

# Sysconfig for Updater
include $(CLEAR_VARS)
LOCAL_MODULE := updater.xml
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/sysconfig
LOCAL_SRC_FILES := etc/sysconfig/updater.xml
include $(BUILD_PREBUILT)

################################
# Copies the APN list file into system/etc for the product as apns-conf.xml.
# In the case where $(CUSTOM_APNS_FILE) is defined, the content of $(CUSTOM_APNS_FILE)
# is added or replaced to the $(DEFAULT_APNS_FILE).
include $(CLEAR_VARS)

LOCAL_MODULE := apns-conf.xml
LOCAL_MODULE_CLASS := ETC

DEFAULT_APNS_FILE := vendor/stag/prebuilt/common/etc/apns-conf.xml

ifdef CUSTOM_APNS_FILE
CUSTOM_APNS_SCRIPT := vendor/stag/tools/custom_apns.py
FINAL_APNS_FILE := $(local-generated-sources-dir)/apns-conf.xml

$(FINAL_APNS_FILE): PRIVATE_SCRIPT := $(CUSTOM_APNS_SCRIPT)
$(FINAL_APNS_FILE): PRIVATE_CUSTOM_APNS_FILE := $(CUSTOM_APNS_FILE)
$(FINAL_APNS_FILE): $(CUSTOM_APNS_SCRIPT) $(DEFAULT_APNS_FILE)
	rm -f $@
	python $(PRIVATE_SCRIPT) $@ $(PRIVATE_CUSTOM_APNS_FILE)
else
FINAL_APNS_FILE := $(DEFAULT_APNS_FILE)
endif

LOCAL_PREBUILT_MODULE_FILE := $(FINAL_APNS_FILE)

include $(BUILD_PREBUILT)
