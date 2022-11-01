# Copyright (C) 2012 The CyanogenMod Project
#           (C) 2017-2022 The LineageOS Project
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


# Android makefile to build kernel as a part of Android Build
#
# Configuration
# =============
#
# These config vars are usually set in BoardConfig.mk:
#
#   TARGET_KERNEL_ADDITIONAL_FLAGS     = Additional make flags, optional
#   TARGET_KERNEL_CONFIG               = List of kernel defconfigs, first one being the base one,
#                                          while all the others are fragments that will be merged
#                                          to main one in .config.
#   TARGET_KERNEL_RECOVERY_CONFIG      = Same as above, but applicable to recovery kernel instead.
#   TARGET_KERNEL_VARIANT_CONFIG       = Variant defconfig, optional
#   TARGET_KERNEL_SELINUX_CONFIG       = SELinux defconfig, optional
#
#   TARGET_KERNEL_CLANG_COMPILE        = Compile kernel with clang, defaults to true
#
#   BOARD_KERNEL_IMAGE_NAME            = Built image name
#                                          for ARM use: zImage
#                                          for ARM64 use: Image.gz
#                                          for uncompressed use: Image
#                                          If using an appended DT, append '-dtb'
#                                          to the end of the image name.
#                                          For example, for ARM devices,
#                                          use zImage-dtb instead of zImage.
#
#   BOARD_DTB_CFG                      = Path to a mkdtboimg.py config file for dtb.img
#
#   BOARD_DTBO_CFG                     = Path to a mkdtboimg.py config file
#
#   BOARD_CUSTOM_DTBIMG_MK             = Path to a custom dtbimage makefile
#
#   BOARD_CUSTOM_DTBOIMG_MK            = Path to a custom dtboimage makefile
#
#   KERNEL_CC                          = The C Compiler used. This is automatically set based
#                                          on whether the clang version is set, optional.
#
#   KERNEL_CLANG_TRIPLE                = Target triple for clang (e.g. aarch64-linux-gnu-)
#                                          defaults to arm-linux-gnu- for arm
#                                                      aarch64-linux-gnu- for arm64
#                                                      x86_64-linux-gnu- for x86
#
#   KERNEL_LTO                         = Optional, force LTO to none / thin / full
#
#   NEED_KERNEL_MODULE_ROOT            = Optional, if true, install kernel
#                                          modules in root instead of vendor
#   NEED_KERNEL_MODULE_SYSTEM          = Optional, if true, install kernel
#                                          modules in system instead of vendor
#   NEED_KERNEL_MODULE_VENDOR_OVERLAY  = Optional, if true, install kernel
#                                          modules in vendor_overlay instead of vendor
#
#   TARGET_FORCE_PREBUILT_KERNEL       = Optional, use TARGET_PREBUILT_KERNEL even if
#                                          kernel sources are present

ifneq ($(TARGET_NO_KERNEL),true)
ifneq ($(TARGET_NO_KERNEL_OVERRIDE),true)

## Externally influenced variables
KERNEL_SRC := $(TARGET_KERNEL_SOURCE)
# kernel configuration - mandatory
KERNEL_DEFCONFIG := $(TARGET_KERNEL_CONFIG)
RECOVERY_DEFCONFIG := $(TARGET_KERNEL_RECOVERY_CONFIG)
VARIANT_DEFCONFIG := $(TARGET_KERNEL_VARIANT_CONFIG)
SELINUX_DEFCONFIG := $(TARGET_KERNEL_SELINUX_CONFIG)

## Internal variables
DTC := $(HOST_OUT_EXECUTABLES)/dtc
PAHOLE := $(HOST_OUT_EXECUTABLES)/pahole
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
RECOVERY_KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/RECOVERY_KERNEL_OBJ
DTBO_OUT := $(TARGET_OUT_INTERMEDIATES)/DTBO_OBJ
DTB_OUT := $(TARGET_OUT_INTERMEDIATES)/DTB_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
KERNEL_RELEASE := $(KERNEL_OUT)/include/config/kernel.release
RECOVERY_KERNEL_CONFIG := $(RECOVERY_KERNEL_OUT)/.config
RECOVERY_KERNEL_RELEASE := $(RECOVERY_KERNEL_OUT)/include/config/kernel.release

ifeq ($(KERNEL_ARCH),x86_64)
KERNEL_DEFCONFIG_ARCH := x86
else
KERNEL_DEFCONFIG_ARCH := $(KERNEL_ARCH)
endif
KERNEL_DEFCONFIG_DIR := $(KERNEL_SRC)/arch/$(KERNEL_DEFCONFIG_ARCH)/configs
ALL_KERNEL_DEFCONFIG_SRCS := $(foreach config,$(KERNEL_DEFCONFIG),$(KERNEL_DEFCONFIG_DIR)/$(config))
ALL_RECOVERY_KERNEL_DEFCONFIG_SRCS := $(foreach config,$(RECOVERY_DEFCONFIG),$(KERNEL_DEFCONFIG_DIR)/$(config))

BASE_KERNEL_DEFCONFIG := $(word 1, $(KERNEL_DEFCONFIG))
BASE_KERNEL_DEFCONFIG_SRC := $(word 1, $(ALL_KERNEL_DEFCONFIG_SRCS))
BASE_RECOVERY_KERNEL_DEFCONFIG := $(word 1, $(RECOVERY_DEFCONFIG))
BASE_RECOVERY_KERNEL_DEFCONFIG_SRC := $(word 1, $(ALL_RECOVERY_KERNEL_DEFCONFIG_SRCS))

ifeq ($(TARGET_PREBUILT_KERNEL),)
    ifeq ($(BOARD_KERNEL_IMAGE_NAME),)
        $(error BOARD_KERNEL_IMAGE_NAME not defined.)
    endif
endif
TARGET_PREBUILT_INT_KERNEL := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/$(BOARD_KERNEL_IMAGE_NAME)

TARGET_PREBUILT_INT_RECOVERY_KERNEL := $(RECOVERY_KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/$(BOARD_KERNEL_IMAGE_NAME)

ifeq "$(wildcard $(KERNEL_SRC) )" ""
    ifneq ($(TARGET_PREBUILT_KERNEL),)
        HAS_PREBUILT_KERNEL := true
        NEEDS_KERNEL_COPY := true
    else
        $(foreach cf,$(PRODUCT_COPY_FILES), \
            $(eval _src := $(call word-colon,1,$(cf))) \
            $(eval _dest := $(call word-colon,2,$(cf))) \
            $(ifeq kernel,$(_dest), \
                $(eval HAS_PREBUILT_KERNEL := true)))
    endif

    ifneq ($(HAS_PREBUILT_KERNEL),)
        $(warning ***************************************************************)
        $(warning * Using prebuilt kernel binary instead of source              *)
        $(warning * THIS IS DEPRECATED, AND IS NOT ADVISED.                     *)
        $(warning * Please configure your device to download the kernel         *)
        $(warning * source repository to $(KERNEL_SRC))
        $(warning * for more information                                        *)
        $(warning ***************************************************************)
        FULL_KERNEL_BUILD := false
        KERNEL_BIN := $(TARGET_PREBUILT_KERNEL)
    else
        $(warning ***************************************************************)
        $(warning *                                                             *)
        $(warning * No kernel source found, and no fallback prebuilt defined.   *)
        $(warning * Please make sure your device is properly configured to      *)
        $(warning * download the kernel repository to $(KERNEL_SRC))
        $(warning * and add the TARGET_KERNEL_CONFIG variable to BoardConfig.mk *)
        $(warning *                                                             *)
        $(warning * As an alternative, define the TARGET_PREBUILT_KERNEL        *)
        $(warning * variable with the path to the prebuilt binary kernel image  *)
        $(warning * in your BoardConfig.mk file                                 *)
        $(warning *                                                             *)
        $(warning ***************************************************************)
        $(error "NO KERNEL")
    endif
else
    NEEDS_KERNEL_COPY := true
    ifeq ($(TARGET_KERNEL_CONFIG),)
        $(warning **********************************************************)
        $(warning * Kernel source found, but no configuration was defined  *)
        $(warning * Please add the TARGET_KERNEL_CONFIG variable to your   *)
        $(warning * BoardConfig.mk file                                    *)
        $(warning **********************************************************)
        $(error "NO KERNEL CONFIG")
    else
        ifneq ($(TARGET_FORCE_PREBUILT_KERNEL),)
            ifneq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(LINEAGE_BUILDTYPE)),)
                $(error "PREBUILT KERNEL IS NOT ALLOWED ON OFFICIAL BUILDS!")
            else
                $(warning **********************************************************)
                $(warning * Kernel source found and configuration was defined,     *)
                $(warning * but prebuilt kernel is being forced.                   *)
                $(warning * While this is likely intentional,                      *)
                $(warning * it is NOT SUPPORTED WHATSOEVER.                        *)
                $(warning * Generated kernel headers may not align with            *)
                $(warning * the ABI of kernel you're including.                    *)
                $(warning * Please unset TARGET_FORCE_PREBUILT_KERNEL              *)
                $(warning * to build the kernel from source.                       *)
                $(warning **********************************************************)
                FULL_KERNEL_BUILD := false
                KERNEL_BIN := $(TARGET_PREBUILT_KERNEL)
            endif
        else
            FULL_KERNEL_BUILD := true
            KERNEL_BIN := $(TARGET_PREBUILT_INT_KERNEL)
        endif
    endif
endif

ifneq ($(TARGET_KERNEL_RECOVERY_CONFIG),)
    ifeq "$(wildcard $(KERNEL_SRC) )" ""
    ifeq ($(TARGET_PREBUILT_RECOVERY_KERNEL),)
        $(warning ***************************************************************)
        $(warning *                                                             *)
        $(warning * No recovery kernel source found, and no fallback prebuilt   *)
        $(warning * defined. Please make sure your device is properly           *)
        $(warning * configured to download the kernel repository to $(KERNEL_SRC))
        $(warning * or remove TARGET_KERNEL_RECOVERY_CONFIG from BoardConfig.mk *)
        $(warning *                                                             *)
        $(warning * Or, define the TARGET_PREBUILT_RECOVERY_KERNEL              *)
        $(warning * variable with the path to the prebuilt recovery kernel image*)
        $(warning * in your BoardConfig.mk file                                 *)
        $(warning *                                                             *)
        $(warning ***************************************************************)
        $(error "NO RECOVERY KERNEL SOURCE")
    endif
    endif
    ifneq ($(BOARD_USES_RECOVERY_AS_BOOT),)
        $(warning ********************************************************)
        $(warning * TARGET_KERNEL_RECOVERY_CONFIG set but device uses    *)
        $(warning * RECOVERY_AS_BOOT, which uses boot kernel as recovery *)
        $(warning * kernel, as such it's not possible to use different   *)
        $(warning * configs                                              *)
        $(warning ********************************************************)
        $(error "INVALID CONFIGURATION")
    else
        FULL_RECOVERY_KERNEL_BUILD := true
        RECOVERY_KERNEL_COPY := true
        RECOVERY_BIN := $(TARGET_PREBUILT_INT_RECOVERY_KERNEL)
    endif
else
    ifneq ($(TARGET_PREBUILT_RECOVERY_KERNEL),)
        RECOVERY_BIN := $(TARGET_PREBUILT_RECOVERY_KERNEL)
        RECOVERY_KERNEL_COPY := true
    endif
endif

ifeq ($(or $(FULL_RECOVERY_KERNEL_BUILD), $(FULL_KERNEL_BUILD)),true)
# Add host bin out dir to path
PATH_OVERRIDE := PATH=$(KERNEL_BUILD_OUT_PREFIX)$(HOST_OUT_EXECUTABLES):$$PATH
ifneq ($(TARGET_KERNEL_CLANG_COMPILE),false)
    ifeq (,$(filter 5.10, $(TARGET_KERNEL_VERSION)))
        ifeq ($(KERNEL_ARCH),arm64)
            KERNEL_CLANG_TRIPLE ?= CLANG_TRIPLE=aarch64-linux-gnu-
        else ifeq ($(KERNEL_ARCH),arm)
            KERNEL_CLANG_TRIPLE ?= CLANG_TRIPLE=arm-linux-gnu-
        else ifeq ($(KERNEL_ARCH),x86)
            KERNEL_CLANG_TRIPLE ?= CLANG_TRIPLE=x86_64-linux-gnu-
        endif
        PATH_OVERRIDE += LD_LIBRARY_PATH=$(TARGET_KERNEL_CLANG_PATH)/lib64:$$LD_LIBRARY_PATH
    endif
    PATH_OVERRIDE += PATH=$(TARGET_KERNEL_CLANG_PATH)/bin:$$PATH
    ifeq ($(KERNEL_CC),)
        KERNEL_CC := CC="$(CCACHE_BIN) clang"
    endif
endif

ifeq ($(TARGET_KERNEL_LLVM_BINUTILS), false)
    # 5.10+ can fully compile without gcc
    ifeq (,$(filter 5.10, $(TARGET_KERNEL_VERSION)))
        PATH_OVERRIDE += PATH=$(KERNEL_TOOLCHAIN_PATH_gcc):$$PATH
    endif
endif

# System tools are no longer allowed on 10+
PATH_OVERRIDE += $(TOOLS_PATH_OVERRIDE)

ifeq (true,$(filter true, $(TARGET_NEEDS_DTBOIMAGE) $(BOARD_KERNEL_SEPARATED_DTBO)))
    KERNEL_MAKE_FLAGS += DTC_EXT=$(KERNEL_BUILD_OUT_PREFIX)$(DTC)
endif

ifneq ($(TARGET_KERNEL_ADDITIONAL_FLAGS),)
    KERNEL_MAKE_FLAGS += $(TARGET_KERNEL_ADDITIONAL_FLAGS)
endif

# Internal implementation of make-kernel-target
# $(1): output path (The value passed to O=)
# $(2): target to build (eg. defconfig, modules, dtbo.img)
define internal-make-kernel-target
$(PATH_OVERRIDE) $(KERNEL_MAKE_CMD) $(KERNEL_MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_BUILD_OUT_PREFIX)$(1) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) $(KERNEL_CLANG_TRIPLE) $(KERNEL_CC) $(2)
endef

# Make an external module target
# $(1): module name
# $(2): module root path
# $(3): target to build (eg. modules_install)
define make-external-module-target
$(PATH_OVERRIDE) $(KERNEL_MAKE_CMD) $(KERNEL_MAKE_FLAGS) -C $(TARGET_KERNEL_EXT_MODULE_ROOT)/$(1) M=$(2)/$(1) KERNEL_SRC=$(BUILD_TOP)/$(KERNEL_SRC) OUT_DIR=$(KERNEL_BUILD_OUT_PREFIX)$(KERNEL_OUT) O=$(KERNEL_BUILD_OUT_PREFIX)$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) $(KERNEL_CLANG_TRIPLE) $(KERNEL_CC) $(3)
endef

# Generate kernel .config from a given defconfig
# $(1): Output path (The value passed to O=)
# $(2): The defconfig to process (just the filename, no need for full path to file)
define make-kernel-config
	$(call internal-make-kernel-target,$(1),VARIANT_DEFCONFIG=$(VARIANT_DEFCONFIG) SELINUX_DEFCONFIG=$(SELINUX_DEFCONFIG) $(2))
	$(hide) if [ "$(KERNEL_LTO)" = "none" ]; then \
			$(KERNEL_SRC)/scripts/config --file $(1)/.config \
			-d LTO_CLANG \
			-e LTO_NONE \
			-d LTO_CLANG_THIN \
			-d LTO_CLANG_FULL \
			-d THINLTO; \
			$(call make-kernel-target,olddefconfig); \
		elif [ "$(KERNEL_LTO)" = "thin" ]; then \
			$(KERNEL_SRC)/scripts/config --file $(1)/.config \
			-e LTO_CLANG \
			-d LTO_NONE \
			-e LTO_CLANG_THIN \
			-d LTO_CLANG_FULL \
			-e THINLTO; \
			$(call make-kernel-target,olddefconfig); \
		elif [ "$(KERNEL_LTO)" = "full" ]; then \
			$(KERNEL_SRC)/scripts/config --file $(1)/.config \
			-e LTO_CLANG \
			-d LTO_NONE \
			-d LTO_CLANG_THIN \
			-e LTO_CLANG_FULL \
			-d THINLTO; \
			$(call make-kernel-target,olddefconfig); \
		fi
	$(hide) if [ ! -z "$(KERNEL_CONFIG_OVERRIDE)" ]; then \
			echo "Overriding kernel config with '$(KERNEL_CONFIG_OVERRIDE)'"; \
			echo $(KERNEL_CONFIG_OVERRIDE) >> $(1)/.config; \
			$(call make-kernel-target,oldconfig); \
		fi
endef

# Make a kernel target
# $(1): The kernel target to build (eg. defconfig, modules, modules_install)
define make-kernel-target
$(call internal-make-kernel-target,$(KERNEL_OUT),$(1))
endef

# Make a recovery kernel target
# $(1): The kernel target to build (eg. defconfig, modules, modules_install)
define make-recovery-kernel-target
$(call internal-make-kernel-target,$(RECOVERY_KERNEL_OUT),$(1))
endef

# Make a DTBO target
# $(1): The DTBO target to build (eg. dtbo.img, defconfig)
define make-dtbo-target
$(call internal-make-kernel-target,$(DTBO_OUT),$(1))
endef

# Make a DTB targets
# $(1): The DTB target to build (eg. dtbs, defconfig)
define make-dtb-target
$(call internal-make-kernel-target,$(DTB_OUT),$(1))
endef

# $(1): modules list
# $(2): output dir
# $(3): mount point
# $(4): staging dir
# $(5): module load list
# Depmod requires a well-formed kernel version so 0.0 is used as a placeholder.
define build-image-kernel-modules-lineage
    mkdir -p $(2)/lib/modules
    cp $(1) $(2)/lib/modules/
    rm -rf $(4)
    mkdir -p $(4)/lib/modules/0.0/$(3)lib/modules
    cp $(1) $(4)/lib/modules/0.0/$(3)lib/modules
    $(DEPMOD) -b $(4) 0.0
    sed -e 's/\(.*modules.*\):/\/\1:/g' -e 's/ \([^ ]*modules[^ ]*\)/ \/\1/g' $(4)/lib/modules/0.0/modules.dep > $(2)/lib/modules/modules.dep
    cp $(4)/lib/modules/0.0/modules.softdep $(2)/lib/modules
    cp $(4)/lib/modules/0.0/modules.alias $(2)/lib/modules
    rm -f $(2)/lib/modules/modules.load
    for MODULE in $(5); do \
        basename $$MODULE >> $(2)/lib/modules/modules.load; \
    done
endef

endif # FULL_RECOVERY_KERNEL_BUILD or FULL_KERNEL_BUILD

ifeq ($(FULL_KERNEL_BUILD),true)

ifeq ($(NEED_KERNEL_MODULE_ROOT),true)
KERNEL_MODULES_OUT := $(TARGET_ROOT_OUT)
KERNEL_DEPMOD_STAGING_DIR := $(KERNEL_BUILD_OUT_PREFIX)$(call intermediates-dir-for,PACKAGING,depmod_recovery)
KERNEL_MODULE_MOUNTPOINT :=
else ifeq ($(NEED_KERNEL_MODULE_SYSTEM),true)
KERNEL_MODULES_OUT := $(TARGET_OUT)
KERNEL_DEPMOD_STAGING_DIR := $(KERNEL_BUILD_OUT_PREFIX)$(call intermediates-dir-for,PACKAGING,depmod_system)
KERNEL_MODULE_MOUNTPOINT := system
$(INSTALLED_SYSTEMIMAGE_TARGET): $(TARGET_PREBUILT_INT_KERNEL)
else ifeq ($(NEED_KERNEL_MODULE_VENDOR_OVERLAY),true)
KERNEL_MODULES_OUT := $(TARGET_OUT_PRODUCT)/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)
KERNEL_DEPMOD_STAGING_DIR := $(KERNEL_BUILD_OUT_PREFIX)$(call intermediates-dir-for,PACKAGING,depmod_product)
KERNEL_MODULE_MOUNTPOINT := vendor
$(INSTALLED_PRODUCTIMAGE_TARGET): $(TARGET_PREBUILT_INT_KERNEL)
else ifeq ($(BOARD_USES_VENDOR_DLKMIMAGE),true)
KERNEL_MODULES_OUT := $(TARGET_OUT_VENDOR_DLKM)
KERNEL_DEPMOD_STAGING_DIR := $(KERNEL_BUILD_OUT_PREFIX)$(call intermediates-dir-for,PACKAGING,depmod_vendor)
KERNEL_MODULE_MOUNTPOINT := vendor_dlkm
$(INSTALLED_VENDOR_DLKMIMAGE_TARGET): $(TARGET_PREBUILT_INT_KERNEL)
else
KERNEL_MODULES_OUT := $(TARGET_OUT_VENDOR)
KERNEL_DEPMOD_STAGING_DIR := $(KERNEL_BUILD_OUT_PREFIX)$(call intermediates-dir-for,PACKAGING,depmod_vendor)
KERNEL_MODULE_MOUNTPOINT := vendor
$(INSTALLED_VENDORIMAGE_TARGET): $(TARGET_PREBUILT_INT_KERNEL)
endif
MODULES_INTERMEDIATES := $(KERNEL_BUILD_OUT_PREFIX)$(call intermediates-dir-for,PACKAGING,kernel_modules)

ifneq (,$(filter dlkm,$(BOARD_VENDOR_RAMDISK_FRAGMENTS)))
KERNEL_VENDOR_RAMDISK_MODULES_OUT := $(VENDOR_RAMDISK_FRAGMENT.dlkm.STAGING_DIR)
KERNEL_VENDOR_RAMDISK_DEPMOD_STAGING_DIR := $(KERNEL_BUILD_OUT_PREFIX)$(call intermediates-dir-for,PACKAGING,depmod_vendor_ramdisk_fragment-stage-dlkm)
$(INTERNAL_VENDOR_RAMDISK_FRAGMENT_TARGETS): $(TARGET_PREBUILT_INT_KERNEL)
else
KERNEL_VENDOR_RAMDISK_MODULES_OUT := $(TARGET_VENDOR_RAMDISK_OUT)
KERNEL_VENDOR_RAMDISK_DEPMOD_STAGING_DIR := $(KERNEL_BUILD_OUT_PREFIX)$(call intermediates-dir-for,PACKAGING,depmod_vendor_ramdisk)
$(INTERNAL_VENDOR_RAMDISK_TARGET): $(TARGET_PREBUILT_INT_KERNEL)
endif

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)

$(KERNEL_CONFIG): $(KERNEL_OUT) $(ALL_KERNEL_DEFCONFIG_SRCS)
	@echo "Building Kernel Config"
	$(call make-kernel-config,$(KERNEL_OUT),$(KERNEL_DEFCONFIG))

$(TARGET_PREBUILT_INT_KERNEL): $(KERNEL_CONFIG) $(DEPMOD) $(DTC) $(PAHOLE)
	@echo "Building Kernel Image ($(BOARD_KERNEL_IMAGE_NAME))"
	$(call make-kernel-target,$(BOARD_KERNEL_IMAGE_NAME))
	$(hide) if grep -q '^CONFIG_OF=y' $(KERNEL_CONFIG); then \
			echo "Building DTBs"; \
			$(call make-kernel-target,dtbs); \
		fi
	$(hide) if grep -q '=m' $(KERNEL_CONFIG); then \
			echo "Building Kernel Modules"; \
			$(call make-kernel-target,modules) || exit "$$?"; \
			echo "Installing Kernel Modules"; \
			$(call make-kernel-target,INSTALL_MOD_PATH=$(MODULES_INTERMEDIATES) INSTALL_MOD_STRIP=1 modules_install); \
			$(if $(TARGET_KERNEL_EXT_MODULES),\
				echo "Building and Installing External Kernel Modules"; \
				rpath=$$(python3 -c 'import os,sys;print(os.path.relpath(*(sys.argv[1:])))' $(TARGET_KERNEL_EXT_MODULE_ROOT) $(KERNEL_SRC)); \
				$(foreach p, $(TARGET_KERNEL_EXT_MODULES),\
					$$pwd; \
					$(call make-external-module-target,$(p),$$rpath,); \
					$(call make-external-module-target,$(p),$$rpath,INSTALL_MOD_PATH=$(MODULES_INTERMEDIATES) INSTALL_MOD_STRIP=1 KERNEL_UAPI_HEADERS_DIR=$(KERNEL_OUT) modules_install)); \
			) \
			kernel_release=$$(cat $(KERNEL_RELEASE)) \
			kernel_modules_dir=$(MODULES_INTERMEDIATES)/lib/modules/$$kernel_release \
			$(foreach s, $(TARGET_MODULE_ALIASES),\
				$(eval p := $(subst :,$(space),$(s))) \
				; mv $$(find $$kernel_modules_dir -name $(word 1,$(p))) $$kernel_modules_dir/$(word 2,$(p))); \
			modules=$$(find $$kernel_modules_dir -type f -name '*.ko'); \
			($(call build-image-kernel-modules-lineage,$$modules,$(KERNEL_MODULES_OUT),$(KERNEL_MODULE_MOUNTPOINT)/,$(KERNEL_DEPMOD_STAGING_DIR),$(BOARD_VENDOR_KERNEL_MODULES_LOAD))); \
			$(if $(BOOT_KERNEL_MODULES),\
				vendor_boot_modules=$$(for m in $(BOOT_KERNEL_MODULES); do \
					p=$$(find $$kernel_modules_dir -type f -name $$m); \
					if [ -n "$$p" ]; then echo $$p; else echo "ERROR: $$m from BOOT_KERNEL_MODULES was not found" 1>&2 && exit 1; fi; \
				done); \
				[ $$? -ne 0 ] && exit 1; \
				($(call build-image-kernel-modules-lineage,$$vendor_boot_modules,$(KERNEL_VENDOR_RAMDISK_MODULES_OUT),/,$(KERNEL_VENDOR_RAMDISK_DEPMOD_STAGING_DIR),$(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD))); \
			) \
		fi

.PHONY: kerneltags
kerneltags: $(KERNEL_CONFIG)
	$(call make-kernel-target,tags)

.PHONY: kernelsavedefconfig alldefconfig

kernelsavedefconfig: $(KERNEL_OUT)
	$(call make-kernel-config,$(KERNEL_OUT),$(BASE_KERNEL_DEFCONFIG))
	$(call make-kernel-target,savedefconfig)
	cp $(KERNEL_OUT)/defconfig $(BASE_KERNEL_DEFCONFIG_SRC)

alldefconfig: $(KERNEL_OUT)
	env KCONFIG_NOTIMESTAMP=true \
		 $(call make-kernel-target,alldefconfig)

ifeq (true,$(filter true, $(TARGET_NEEDS_DTBOIMAGE) $(BOARD_KERNEL_SEPARATED_DTBO)))
ifneq ($(BOARD_CUSTOM_DTBOIMG_MK),)
include $(BOARD_CUSTOM_DTBOIMG_MK)
else
MKDTIMG := $(HOST_OUT_EXECUTABLES)/mkdtimg$(HOST_EXECUTABLE_SUFFIX)
MKDTBOIMG := $(HOST_OUT_EXECUTABLES)/mkdtboimg.py$(HOST_EXECUTABLE_SUFFIX)

$(DTBO_OUT):
	mkdir -p $(DTBO_OUT)

$(BOARD_PREBUILT_DTBOIMAGE): $(DTC) $(MKDTIMG) $(MKDTBOIMG) $(DTBO_OUT)
$(BOARD_PREBUILT_DTBOIMAGE):
	@echo "Building dtbo.img"
	$(hide) find $(DTBO_OUT)/arch/$(KERNEL_ARCH)/boot/dts -type f -name "*.dtbo" | xargs rm -f
	$(call make-dtbo-target,$(KERNEL_DEFCONFIG))
	$(call make-dtbo-target,$(TARGET_KERNEL_DTB))
ifeq ($(BOARD_KERNEL_SEPARATED_DTBO),true)
	$(call make-dtbo-target,dtbs)
ifdef BOARD_DTBO_CFG
	$(MKDTBOIMG) cfg_create $@ $(BOARD_DTBO_CFG) -d $(DTBO_OUT)/arch/$(KERNEL_ARCH)/boot/dts
else
	$(MKDTBOIMG) create $@ --page_size=$(BOARD_KERNEL_PAGESIZE) $(shell find $(DTBO_OUT)/arch/$(KERNEL_ARCH)/boot/dts -type f -name "*.dtbo" | sort)
endif # BOARD_DTBO_CFG
else
	$(call make-dtbo-target,$(TARGET_KERNEL_DTBO))
endif # BOARD_KERNEL_SEPARATED_DTBO
	$(hide) touch -c $(DTBO_OUT)
endif # BOARD_CUSTOM_DTBOIMG_MK
endif # TARGET_NEEDS_DTBOIMAGE/BOARD_KERNEL_SEPARATED_DTBO

ifeq ($(BOARD_INCLUDE_DTB_IN_BOOTIMG),true)
ifneq ($(BOARD_CUSTOM_DTBIMG_MK),)
include $(BOARD_CUSTOM_DTBIMG_MK)
else
ifeq ($(BOARD_PREBUILT_DTBIMAGE_DIR),)
$(DTB_OUT):
	mkdir -p $(DTB_OUT)

ifdef BOARD_DTB_CFG
MKDTBOIMG := $(HOST_OUT_EXECUTABLES)/mkdtboimg.py$(HOST_EXECUTABLE_SUFFIX)
$(INSTALLED_DTBIMAGE_TARGET): $(MKDTBOIMG)
endif
$(INSTALLED_DTBIMAGE_TARGET): $(DTC) $(DTB_OUT)
ifeq ($(TARGET_WANTS_EMPTY_DTB),true)
	@rm -f $@
	echo "empty" > $@
else
	@echo "Building dtb.img"
	$(hide) find $(DTB_OUT)/arch/$(KERNEL_ARCH)/boot/dts -type f -name "*.dtb" | xargs rm -f
	$(call make-dtb-target,$(KERNEL_DEFCONFIG))
	$(call make-dtb-target,$(TARGET_KERNEL_DTB))
ifdef BOARD_DTB_CFG
	$(MKDTBOIMG) cfg_create $@ $(BOARD_DTB_CFG) -d $(DTB_OUT)/arch/$(KERNEL_ARCH)/boot/dts
else
	cat $(shell find $(DTB_OUT)/arch/$(KERNEL_ARCH)/boot/dts -type f -name "*.dtb" | sort) > $@
endif # BOARD_DTB_CFG
	$(hide) touch -c $(DTB_OUT)
endif # !TARGET_WANTS_EMPTY_DTB

endif # !BOARD_PREBUILT_DTBIMAGE_DIR
endif # BOARD_CUSTOM_DTBIMG_MK
endif # BOARD_INCLUDE_DTB_IN_BOOTIMG

endif # FULL_KERNEL_BUILD

ifeq ($(FULL_RECOVERY_KERNEL_BUILD),true)

$(RECOVERY_KERNEL_OUT):
	mkdir -p $(RECOVERY_KERNEL_OUT)

$(RECOVERY_KERNEL_CONFIG): $(ALL_RECOVERY_KERNEL_DEFCONFIG_SRCS)
	@echo "Building Recovery Kernel Config"
	$(call make-kernel-config,$(RECOVERY_KERNEL_OUT),$(RECOVERY_DEFCONFIG))

$(TARGET_PREBUILT_INT_RECOVERY_KERNEL): $(RECOVERY_KERNEL_CONFIG) $(DEPMOD) $(DTC) $(PAHOLE)
	@echo "Building Recovery Kernel Image ($(BOARD_KERNEL_IMAGE_NAME))"
	$(call make-recovery-kernel-target,$(BOARD_KERNEL_IMAGE_NAME))


endif

## Install it

ifeq ($(NEEDS_KERNEL_COPY),true)
$(INSTALLED_KERNEL_TARGET): $(KERNEL_BIN)
	$(transform-prebuilt-to-target)
endif

ifeq ($(RECOVERY_KERNEL_COPY),true)
$(INSTALLED_RECOVERY_KERNEL_TARGET): $(RECOVERY_BIN)
	$(transform-prebuilt-to-target)
endif

.PHONY: recovery-kernel
recovery-kernel: $(INSTALLED_RECOVERY_KERNEL_TARGET)

.PHONY: kernel
kernel: $(INSTALLED_KERNEL_TARGET)

.PHONY: dtboimage
dtboimage: $(INSTALLED_DTBOIMAGE_TARGET)

.PHONY: dtbimage
dtbimage: $(INSTALLED_DTBIMAGE_TARGET)

endif # TARGET_NO_KERNEL_OVERRIDE
endif # TARGET_NO_KERNEL
