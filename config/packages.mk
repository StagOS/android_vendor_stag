# Copyright (C) 2018 StagOS
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

# Required packages
PRODUCT_PACKAGES += \
    Aves \
    BluetoothExt \
    Calendar \
    Contacts \
    DeskClock \
    Dialer \
    ExactCalculator \
    Jelly \
    LatinIME \
    Launcher3QuickStep \
    LiveWallpapersPicker \
    messaging \
    PixelLiveWallpaperPrebuilt \
    OmniSwitch \
    OPScreenRecorder \
    Phonograph \
    PixelThemesStub \
    StagWalls \
    StagThemesStub \
    StitchImage \
    Stk \
    ThemePicker

#ifeq ($(TARGET_INCLUDE_LAWNCHAIR),true)
#PRODUCT_PACKAGES += \
#    Lawnchair
#endif

# Accents
#PRODUCT_PACKAGES += \
#    AccentColorYellowOverlay \
#    AccentColorVioletOverlay \
#    AccentColorTealOverlay \
#    AccentColorRedOverlay \
#    AccentColorQGreenOverlay \
#    AccentColorPinkOverlay \
#    AccentColorPixelBlueOverlay \
#    AccentColorLightPurpleOverlay \
#    AccentColorIndigoOverlay \
#    AccentColorFlatPinkOverlay \
#    AccentColorCyanOverlay \
#    AccentColorBlueGrayOverlay

# Gradient
PRODUCT_PACKAGES += \
    AccentColorGradientIndianOverlay

# Custom Overlays
# Settings
PRODUCT_PACKAGES += \
    SystemPitchBlackOverlay \
    SystemUIPitchBlackOverlay \
    SystemDarkGrayOverlay \
    SystemUIDarkGrayOverlay \
    SystemStyleOverlay \
    SystemUIStyleOverlay \
    SystemNightOverlay \
    SystemUINightOverlay \
    SystemSolarizedDarkOverlay \
    SystemUISolarizedDarkOverlay \
    SystemMaterialOceanOverlay \
    SystemUIMaterialOceanOverlay \
    SystemBakedGreenOverlay \
    SystemUIBakedGreenOverlay \
    SystemChocoXOverlay \
    SystemUIChocoXOverlay \
    SystemClearSpringOverlay \
    SystemUIClearSpringOverlay \

# Extra tools
PRODUCT_PACKAGES += \
    7z \
    bash \
    bzip2 \
    curl \
    e2fsck \
    fsck.ntfs \
    gdbserver \
    htop \
    lib7z \
    libsepol \
    micro_bench \
    mke2fs \
    mkfs.ntfs \
    mount.ntfs \
    nano \
    openvpn \
    oprofiled \
    pigz \
    powertop \
    sqlite3 \
    strace \
    tune2fs \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# exFAT tools
 PRODUCT_PACKAGES += \
    fsck.exfat \
    mkfs.exfat

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank
endif

# Charger images
PRODUCT_PACKAGES += \
    charger_res_images

# Gradients
#PRODUCT_PACKAGES += \
#    BlueSkyTheme \
#    CherryTheme \
#    DeepSkylineTheme \
#    DeepSunsetTheme \
#    DefaultTheme \
#    FireTheme \
#    FlareTheme \
#    GrapeVineTheme \
#    HyakkimaruTheme \
#    KyeMehTheme \
#    LavenderTheme \
#    LightSeaStormTheme \
#    OrangeCoralTheme \
#    PeachyTheme \
#    PolarGreenTheme \
#    PureLustTheme \
#    QuepalTheme \
#    ReaTheme \
#    SeaStormTheme \
#    ShadesofGreyTheme \
#    SinCityRedTheme \
#    SkylineTheme \
#    SublimeTheme \
#    TimberTheme \
#    WitchingHourTheme \
#    YodaTheme

# Recorder
#PRODUCT_PACKAGES += \
#    Recorder

# OmniStyle
#PRODUCT_PACKAGES += \
#    OmniStyle

#Custom Overlays
#PRODUCT_PACKAGES += \
#    SystemPitchBlackOverlay \
#    SystemDarkGrayOverlay \
#    SystemUIDarkGrayOverlay \
#    SystemStyleOverlay \
#    SystemUIStyleOverlay \
#    SystemNightOverlay \
#    SystemUINightOverlay

# QS tile styles
#PRODUCT_PACKAGES += \
#    QStileCircleTrim \
#    QStileDefault \
#    QStileDualToneCircle \
#    QStileSquircleTrim \
#    QStileAttemptMountain \
#    QStileDottedCircle \
#    QStileNinja \
#    QStilePokesign \
#    QStileWavey \
#    QStileCookie \
#    QStileInkDrop \
#    QStileIconAccent \
#    QStileSquaremedo \
#    QStileCosmos \
#    QStileDividedCircle \
#    QStileNeonLight \
#    QStileOxygen \
#    QStileTriangles \
#    QStileCircleOutline

# Icon Shapes
include vendor/stag/config/iconshapes.mk
