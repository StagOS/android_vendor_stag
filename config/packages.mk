
# Copyright (C) 2018 The StagOS
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
    BluetoothExt \
    Calendar \
    ExactCalculator \
    LatinIME \
    Launcher3QuickStep \
    messaging \
    Stk \
    LiveWallpapers \
    LiveWallpapersPicker



# Themes Black
PRODUCT_PACKAGES += \
    SettingsBlackTheme \
    SystemBlackTheme \
    SystemUIBlackTheme

# Themes Dark
PRODUCT_PACKAGES += \
    GBoardDark \
    GoogleIntelligenceSenseDark \
    SettingsDark \
    SettingsIntelligenceDark \
    SystemDark \
    SystemUiDark \
    SystemShishuNightsTheme \
    SettingsShishuNightsTheme \
    SystemUIShishuNightsTheme \
    WellbeingThemeShishuNights \
    WellbeingDark

# Overlays
PRODUCT_PACKAGES += \
    AmberAccent \
    BlackAccent \
    BlueAccent \
    BlueGreyAccent \
    BrownAccent \
    CandyRed \
    CyanAccent \
    DeepOrangeAccent \
    DeepPurpleAccent \
    ExtendedGreen \
    DuiDark \
    GBoardDark \
    GreenAccent \
    GreyAccent \
    IndigoAccent \
    JadeGreen \
    LightBlueAccent \
    LightGreenAccent \
    LimeAccent \
    OrangeAccent \
    PaleBlue \
    PaleRed \
    PinkAccent \
    PurpleAccent \
    RedAccent \
    SettingsDark \
    SystemDark \
    TealAccent \
    YellowAccent \
    WhiteAccent \
    UserOne \
    UserTwo \
    UserThree \
    UserFour \
    UserFive \
    UserSix \
    UserSeven \
    ObfusBleu \
    NotImpPurple \
    Holillusion \
    MoveMint \
    FootprintPurple \
    BubblegumPink \
    FrenchBleu \
    Stock \
    ManiaAmber \
    SeasideMint \
    DreamyPurple \
    SpookedPurple \
    HeirloomBleu \
    TruFilPink \
    WarmthOrange \
    ColdBleu \
    DiffDayGreen \
    DuskPurple \
    BurningRed \
    HazedPink \
    ColdYellow \
    NewHouseOrange \
    IllusionsPurple

#QS Styles
PRODUCT_PACKAGES += \
	QSTileSquircle \
	QSTileTearDrop \
	QSTileCircleDual \
	QSTileCircleGradient \
	QSTileInkdrop \
	QSTileIconAccent \
	QSTileShishuNights \
	QSTileMemedoSquare \
	QSTileWavey \
	QSTileAttemptMountain \
	QSTileDottedCircle \
	QSTileNinja \
	QSTilePokesign \
	QSTileShishuInk \
        QSTileCookie \
        QSTileCosmos \
        QSTileDividedCircle \
        QSTileNeonLight \
        QSTileOxygen \
        QSTileTriangles

# Gradients
PRODUCT_PACKAGES += \
    BlueSkyTheme \
    CherryTheme \
    DeepSkylineTheme \
    DeepSunsetTheme \
    FireTheme \
    FlareTheme \
    GrapeVineTheme \
    HyakkimaruTheme \
    KyeMehTheme \
    LavenderTheme \
    LightSeaStormTheme \
    OrangeCoralTheme \
    PeachyTheme \
    PolarGreenTheme \
    PureLustTheme \
    QuepalTheme \
    ReaTheme \
    SeaStormTheme \
    ShadesofGreyTheme \
    SinCityRedTheme \
    SkylineTheme \
    SublimeTheme \
    TimberTheme \
    WitchingHourTheme  \
    YodaTheme

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

# Turbo
PRODUCT_PACKAGES += \
    Turbo \
    turbo.xml

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

# Default PACKAGES
PRODUCT_PACKAGES += \
    charger_res_images \
    Launcher3 \
    ViaBrowser \
    Phonograph \
    OmniStyle \
    StagWalls

# Google
PRODUCT_PACKAGES += \
    PrebuiltBugle \
    WellbeingPrebuilt \
    PrebuiltDeskClockGoogle \
    GoogleServicesFramework \
    Calculator \
    SubstratumSignature

#Font package
PRODUCT_PACKAGES += \
    Custom-Fonts

#Weather package
PRODUCT_PACKAGES += \
    WeatherClient

# QS accents
PRODUCT_PACKAGES += \
    QSAccentBlack \
    QSAccentWhite

# Switch Styles
PRODUCT_PACKAGES += \
    MD2Switch \
    OnePlusSwitch \
    StockSwitch

# Updater
PRODUCT_PACKAGES += \
    Updater \
    updater.xml

#Doze
PRODUCT_PACKAGES += \
    CustomDoze \
