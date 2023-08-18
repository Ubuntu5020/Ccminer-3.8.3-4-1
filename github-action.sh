#!/bin/bash

# Get CPU information
arch=$(lscpu | awk '/Architecture:/ { print $2 }')
model_name=$(lscpu | awk -F ': +' '/Model name:/ { print $2 }')

# Common compiler flags
common_flags="-O3 -ffinite-loops -ffast-math -D_REENTRANT -finline-functions -falign-functions=16 -fomit-frame-pointer -fpic -pthread -flto -fuse-ld=lld -fno-stack-protector"

# List of SPU model names
#spu_models=("Cortex-A53" "Cortex-A55" "Cortex-A57" "Cortex-A72" "Cortex-A73" "Cortex-A75" "Cortex-A76" "Cortex-A78c" "Cortex-A78")
spu_models=("Cortex-A53" "Cortex-A55")

# Create a directory to store the zip files
sudo mkdir -p ../ccminer/

# Loop through the SPU model names
for model_name in "${spu_models[@]}"; do
    echo "Configuring, building, and installing $model_name..."

    # Generate CPU flags based on model name
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
        echo "Unknown model name: $model_name"
        continue
    fi

    # Set vectorization flags
    vectorization_flags="-Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize -Wl"
    
    # Combine all flags
    all_flags="$common_flags $cpu_flags $vectorization_flags"
    
    
    # Configure and build
    ./configure --target=aarch64-linux-gnu --host=aarch64-linux-gnu --build=x86_64-linux-gnu \
                CXXFLAGS="-Wl,-hugetlbfs-align -funroll-loops -finline-functions $all_flags" \
                CFLAGS="-Wl,-hugetlbfs-align -finline-functions $all_flags" \
                CXX=clang++ CC=clang LDFLAGS="-v -flto -Wl,-hugetlbfs-align"
    
    sudo make
    sudo make install

    # Create a zip file
    zip -r "ccminer_$model_name.zip" ./
    ls ./
    mv "ccminer_$model_name.zip" ../ccminer/
    ls ../ccminer/
    echo "$model_name done!"
done

echo "All models have been processed."


