#!/bin/bash

# Get CPU information
arch=$(lscpu | awk '/Architecture:/ { print $2 }')
model_name=$(lscpu | awk -F ': +' '/Model name:/ { print $2 }')

# Common compiler flags
common_flags="-O3 -ffinite-loops -ffast-math -D_REENTRANT -finline-functions -falign-functions=16 -fomit-frame-pointer -fpic -pthread -flto -fuse-ld=lld -fno-stack-protector -enable-loop-distribute"

# Set architecture-specific flags
if [[ "$arch" == "aarch64" ]]; then
    case "$model_name" in
        "Cortex-A53")
            cpu_flags="-march=armv8-a+crypto -mfpu=crypto-neon-fp-armv8 -mfloat-abi=hard -mtune=cortex-a53"
            ;;
        "Cortex-A72")
            cpu_flags="-march=armv8-a+crypto -mfpu=crypto-neon-fp-armv8 -mfloat-abi=hard -mtune=cortex-a72"
            ;;
        "Cortex-A73")
            cpu_flags="-march=armv8.2-a+crypto -mfpu=crypto-neon-fp-armv8 -mfloat-abi=hard -mtune=cortex-a73"
            ;;
        "Cortex-A75")
            cpu_flags="-march=armv8.2-a+crypto -mfpu=crypto-neon-fp-armv8 -mfloat-abi=hard -mtune=cortex-a75"
            ;;
        "Cortex-A76")
            cpu_flags="-march=armv8.2-a+crypto -mfpu=crypto-neon-fp-armv8 -mfloat-abi=hard -mtune=cortex-a76"
            ;;
        "Cortex-A77")
            cpu_flags="-march=armv8.2-a+crypto -mfpu=crypto-neon-fp-armv8 -mfloat-abi=hard -mtune=cortex-a77"
            ;;
        "Cortex-A78")
            cpu_flags="-march=armv8.2-a+crypto -mfpu=crypto-neon-fp-armv8 -mfloat-abi=hard -mtune=cortex-a78"
            ;;
        "Cortex-A78c")
            cpu_flags="-march=armv8.2-a+crypto -mfpu=crypto-neon-fp-armv8 -mfloat-abi=hard -mtune=cortex-a78c"
            ;;
        *)
            # Default to ARMv8-A architecture (Cortex-A53) if unknown
            echo "Unknown or unsupported model: $model_name. Defaulting to ARMv8-A."
            cpu_flags="-march=armv8-a+crypto -mfpu=crypto-neon-fp-armv8 -mfloat-abi=hard -mtune=cortex-a53"
            ;;
    esac
else
    # Default to ARMv8-A architecture (Cortex-A53) if unknown
    echo "Unknown or unsupported architecture: $arch. Defaulting to Native Tuning."
    cpu_flags="-mtune=native"
fi


# Set vectorization flags
vectorization_flags="-Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize -Wl"

# Combine all flags
all_flags="$common_flags $cpu_flags $vectorization_flags"


# Configure and build
./configure --host=aarch64-linux-gnu CXXFLAGS="-Wl,-hugetlbfs-align -funroll-loops -finline-functions $all_flags" \
            CFLAGS="-Wl,-hugetlbfs-align -finline-functions $all_flags" \
            CXX=clang++ CC=clang LDFLAGS="-v -flto -Wl,-hugetlbfs-align"

# Configure and build with GCC
 # ./configure  --build x86_64-pc-linux-gnu --host aarch64-linux-gnu --target aarch64-linux-gnu  CXXFLAGS="-Wl, -funroll-loops -finline-functions $all_flags" \
 #             CFLAGS="-finline-functions $all_flags" \
 #             CXX=g++ CC=gcc LDFLAGS="-v -flto -Wl,-hugetlbfs-align"


