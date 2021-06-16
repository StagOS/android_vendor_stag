#!/usr/bin/env python3
# Copyright (C) 2012-2013, The CyanogenMod Project
# Copyright (C) 2012-2015, SlimRoms Project
# Copyright (C) 2016-2018, AOSiP
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

import os
import sys
import shutil
from pathlib import Path

DEBUG = False

def debug(*args, **kwargs):
    if DEBUG:
        print(*args, **kwargs)

def getRomDetails(device):
    if not "AndroidProducts.mk" in os.listdir():
        debug("AndroidProducts.mk missing")
        sys.exit()
    with open("AndroidProducts.mk", "r") as ap:
        lines = ap.readlines()
    line_iterator = iter(lines)
    for line in line_iterator:
        if "PRODUCT_MAKEFILES" in line:
            if ".mk" not in line:
                line = next(line_iterator)
                if ".mk" not in line:
                    debug("Could not find makefile for rom_device")
                    sys.exit()
            for i in line.split("/"):
                if ".mk" in i:
                    makefile = i.split("\n")[0].strip()
        if device in line:
            rom = line.split("_"+device)[0].strip()
    if not rom or not makefile:
        debug("Could not find romname and makefile")
        sys.exit()
    return([rom, makefile])

def updateAP(rom, rom_makefile, device):
    try:
        with open("AndroidProducts.mk", "r") as ap:
            lines = ap.read()
    except Exception as e:
        debug("Failed to update AndroidProducts ", e)
        sys.exit()

    lines=lines.replace(rom_makefile, "stag_"+device+".mk")
    lines=lines.replace(rom, "stag")
    try:
        with open("AndroidProducts.mk", "w") as ap:
            ap.write(lines)
    except Exception as e:
        debug("Failed to update AndroidProducts ", e)
        sys.exit()

def updateMakefile(rom, rom_makefile, device):
    print(rom, rom_makefile)
    stag_rom_makefile = "stag_"+device+".mk"
    try:
        shutil.copy2(rom_makefile, stag_rom_makefile)
    except shutil.SameFileError:
        debug("File already exists")
    try:
        with open(stag_rom_makefile, "r") as stag_makefile:
            lines = stag_makefile.readlines()
        for i in range(len(lines)):
            if "vendor" in lines[i] and rom in lines[i]:
                lines[i]='$(call inherit-product, vendor/stag/main.mk)\n'
            elif rom in lines[i]:
                lines[i]=lines[i].replace(rom+"_"+device, "stag_"+device)       
        lines=''.join(lines)
        with open(stag_rom_makefile, "w") as stag_makefile:
            stag_makefile.write(lines)

    except Exception as e:
        debug("Failed to update AndroidProducts ", e)
        sys.exit()

def main():
    global DEBUG
    path = Path(r".")
    if os.getenv('STAGIFY_DEBUG'):
        DEBUG = True

    product = sys.argv[1]
    device = product[product.find("_") + 1:].strip() or product
    print("Stagified Device tree for device {0} not found. Attempting to find device tree structure locally ".format(device))
    try:
        device_tree_path = list(path.glob("device/*/" + device))[0]
    except IndexError:
        print("Failed to find tree locally.")
        sys.exit()
    print("Found {}".format(device_tree_path))
    try:
        os.chdir(device_tree_path)
    except Exception as e:
        debug("Changing dir failed", e)
        sys.exit()
    rom, rom_makefile = getRomDetails(device)
    if rom == "stag":
        print("Tree seems to be stagified, trying to fix inconsistencies")
    else:
        print("Stagifying ", rom_makefile)
    updateAP(rom, rom_makefile, device)
    updateMakefile(rom, rom_makefile, device)
    if rom == "stag":
        print("Tried fixes on stagiefied tree")
    else:
        print("Tree for {0} stagified successfully".format(device))

if __name__ == "__main__":
    main()
