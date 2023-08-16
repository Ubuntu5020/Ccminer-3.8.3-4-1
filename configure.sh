#!/bin/bash

# Get CPU information
arch=$(lscpu | awk '/Architecture:/ { print $2 }')
model_name=$(lscpu | awk -F ': +' '/Model name:/ { print $2 }')

# Common compiler flags
common_flags="-O3 -ffinite-loops -ffast-math -D_REENTRANT -finline-functions -falign-functions=16 -fomit-frame-pointer -fpic -pthread -flto -fuse-ld=lld -fno-stack-protector"

# Set architecture-specific flags
if [[ "$arch" == "aarch64" ]]; then
    if [[ "$model_name" == *"Cortex-A53"* ]]; then
        cpu_flags="-march=armv8-a+crypto -mtune=cortex-a53"
    elif [[ "$model_name" == *"Cortex-A55"* ]]; then
        cpu_flags="-march=armv8-a+crypto -mtune=cortex-a55"
    elif [[ "$model_name" == *"Cortex-A57"* ]]; then
        cpu_flags="-march=armv8-a+crypto -mtune=cortex-a57"
    elif [[ "$model_name" == *"Cortex-A72"* ]]; then
        cpu_flags="-march=armv8-a+crypto -mtune=cortex-a72"
    elif [[ "$model_name" == *"Cortex-A73"* ]]; then
        cpu_flags="-march=armv8-a+crypto -mtune=cortex-a73"
    elif [[ "$model_name" == *"Cortex-A75"* ]]; then
        cpu_flags="-march=armv8-a+crypto -mtune=cortex-a75"
    elif [[ "$model_name" == *"Cortex-A76"* ]]; then
        cpu_flags="-march=armv8-a+crypto -mtune=cortex-a76"
    elif [[ "$model_name" == *"Cortex-A77"* ]]; then
        cpu_flags="-march=armv8-a+crypto -mtune=cortex-a77"
    elif [[ "$model_name" == *"Cortex-A78c"* ]]; then
        cpu_flags="-march=armv8-a+crypto -mtune=cortex-a78c"
    elif [[ "$model_name" == *"Cortex-A78"* ]]; then
        cpu_flags="-march=armv8-a+crypto -mtune=cortex-a78"
    else
        # Default to ARMv8-A architecture (Cortex-A53) if unknown
        echo "Unknown or unsupported model: $model_name. Defaulting to ARMv8-A."
        cpu_flags="-march=armv8-a+crypto -mtune=cortex-a53"
    fi
else
    # Default to ARMv8-A architecture (Cortex-A53) if unknown architecture
    echo "Unknown or unsupported architecture: $arch. Defaulting to Native Tuning."
    cpu_flags="-mtune=native"
fi

# Set vectorization flags
vectorization_flags="-Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize -Wl"

# Combine all flags
all_flags="$common_flags $cpu_flags $vectorization_flags"


# Configure and build
./configure --target=aarch64-linux-gnu --host=x86_64-linux-gnu --build=x86_64-linux-gnu \
            CXXFLAGS="-Wl,-hugetlbfs-align -funroll-loops -finline-functions $all_flags" \
            CFLAGS="-Wl,-hugetlbfs-align -finline-functions $all_flags" \
            CXX=clang++ CC=clang LDFLAGS="-v -flto -Wl,-hugetlbfs-align"

# Configure and build with GCC
 # ./configure  --build x86_64-pc-linux-gnu --host aarch64-linux-gnu --target aarch64-linux-gnu  CXXFLAGS="-Wl, -funroll-loops -finline-functions $all_flags" \
 #             CFLAGS="-finline-functions $all_flags" \
 #             CXX=g++ CC=gcc"


