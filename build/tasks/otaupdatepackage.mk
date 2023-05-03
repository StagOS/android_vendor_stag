# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017 The LineageOS Project
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

# -----------------------------------------------------------------
# Stag fastboot update package and OTA package (for recovery)

# Build system colors
 ifneq ($(BUILD_WITH_COLORS),0)
  CL_RED="\033[31m"
  CL_GRN="\033[32m"
  CL_YLW="\033[33m"
  CL_BLU="\033[34m"
  CL_MAG="\033[35m"
  CL_CYN="\033[36m"
  CL_RST="\033[0m"
endif

STAG_TARGET_UPDATEPACKAGE := $(PRODUCT_OUT)/$(STAG_VERSION)-updatepackage.zip
STAG_TARGET_PACKAGE := $(PRODUCT_OUT)/$(STAG_VERSION).zip
MD5 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/md5sum

.PHONY: stagotaupdatepackage
stagotaupdatepackage: $(INTERNAL_UPDATE_PACKAGE_TARGET) $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_UPDATE_PACKAGE_TARGET) $(STAG_TARGET_UPDATEPACKAGE)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(STAG_TARGET_PACKAGE)
	$(hide) $(MD5) $(STAG_TARGET_UPDATEPACKAGE) > $(STAG_TARGET_UPDATEPACKAGE).md5sum
	$(hide) $(MD5) $(STAG_TARGET_PACKAGE) > $(STAG_TARGET_PACKAGE).md5sum

	echo -e ${CL_RED}"    ______________   ______      ____  _____"${CL_RST}
	echo -e ${CL_GRN}"   / ___/_  __/   | / ____/     / __ \/ ___/"${CL_RST}
	echo -e ${CL_CYN}"   \__ \ / / / /| |/ / ________/ / / /\__ \ "${CL_RST}
	echo -e ${CL_BLU}"  ___/ // / / ___ / /_/ /_____/ /_/ /___/ / "${CL_RST}
	echo -e ${CL_MAG}" /____//_/ /_/  |_\____/      \____//____/  "${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"===============-Sic Parvis Magna-==============="${CL_RST}
	echo -e ${CL_BLD}${CL_YLW}"OTA: "${CL_YLW} $(STAG_VERSION).zip${CL_RST}
	echo -e ${CL_BLD}${CL_YLW}"MD5: "${CL_YLW}" `cat $(STAG_TARGET_PACKAGE).md5sum | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_YLW}"Size:"${CL_YLW}" `du -sh $(STAG_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_YLW}"UP: "${CL_YLW} $(STAG_VERSION)-updatepackage.zip${CL_RST}
	echo -e ${CL_BLD}${CL_YLW}"MD5: "${CL_YLW}" `cat $(STAG_TARGET_UPDATEPACKAGE).md5sum | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_YLW}"Size:"${CL_YLW}" `du -sh $(STAG_TARGET_UPDATEPACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"====================================================="${CL_RST}
