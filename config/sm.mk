# Written for SaberMod toolchains
# Find host os

# Set GCC colors
export GCC_COLORS := 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

UNAME := $(shell uname -sm)

ifeq (Linux,$(UNAME))
  HOST_OS := linux
endif

# Only use these compilers on linux host.
ifeq (linux,$(HOST_OS))

# Add extra libs for the compilers to use
# Filter by TARGET_ARCH since we're pointing to ARCH specific compilers.
# To use this on new devices define TARGET_ARCH in device makefile.
ifeq (arm,$(TARGET_ARCH))
export LD_LIBRARY_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-4.8/arch-arm/usr/lib
export LIBRARY_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-4.8/arch-arm/usr/lib

# Path to toolchain
SM_AND_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-4.8
SM_AND := $(shell $(SM_AND_PATH)/bin/arm-linux-androideabi-gcc --version)

# Find strings in version info
ifneq ($(filter (SaberMod%),$(SM_AND)),)
SM_AND_NAME := $(filter (SaberMod%),$(SM_AND))
SM_AND_DATE := $(filter 20140% 20141% 20150% 20151%,$(SM_AND))
SM_AND_STATUS := $(filter (release) (prerelease) (experimental),$(SM_AND))
SM_AND_VERSION := $(SM_AND_NAME)-$(SM_AND_DATE)-$(SM_AND_STATUS)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.sm.android=$(SM_AND_VERSION)

SM_KERNEL_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-eabi-4.9
SM_KERNEL := $(shell $(SM_KERNEL_PATH)/bin/arm-eabi-gcc --version)

ifneq ($(filter (SaberMod%),$(SM_KERNEL)),)
SM_KERNEL_NAME := $(filter (SaberMod%),$(SM_KERNEL))
SM_KERNEL_DATE := $(filter 20140% 20141% 20150% 20151%,$(SM_KERNEL))
SM_KERNEL_STATUS := $(filter (release) (prerelease) (experimental),$(SM_KERNEL))
SM_KERNEL_VERSION := $(SM_KERNEL_NAME)-$(SM_KERNEL_DATE)-$(SM_KERNEL_STATUS)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sm.kernel=$(SM_KERNEL_VERSION)
endif

ifeq (true,$(GRAPHITE_OPTS))
OPT1 := (graphite)
endif
endif

ifeq (arm64,$(TARGET_ARCH))
export LD_LIBRARY_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-4.9/arch-arm64/usr/lib
export LIBRARY_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-4.9/arch-arm64/usr/lib

# Path to toolchain
SM_AND_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-4.9
SM_AND := $(shell $(SM_AND_PATH)/bin/aarch64-linux-android-gcc --version)

# Find strings in version info
ifneq ($(filter (SaberMod%),$(SM_AND)),)
SM_AND_NAME := $(filter (SaberMod%),$(SM_AND))
SM_AND_DATE := $(filter 20140% 20141% 20150% 20151%,$(SM_AND))
SM_AND_STATUS := $(filter (release) (prerelease) (experimental),$(SM_AND))
SM_AND_VERSION := $(SM_AND_NAME)-$(SM_AND_DATE)-$(SM_AND_STATUS)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sm.android=$(SM_AND_VERSION)
endif

ifeq (true,$(GRAPHITE_OPTS))
OPT1 := (graphite)
endif
endif
endif

ifeq (true,$(STRICT_ALIASING))
OPT2 := (strict)
endif

ifeq (true,$(USE_O3_OPTIMIZATIONS))
OPT3 := (extreme)
endif

GCC_OPTIMIZATION_LEVELS := $(OPT1)$(OPT2)$(OPT3)
ifneq (,$(GCC_OPTIMIZATION_LEVELS))
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sm.flags=$(GCC_OPTIMIZATION_LEVELS)
endif

