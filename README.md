# ccminer for ARM (cortex-a53)

Based on https://github.com/monkins1010/ccminer/tree/ARM

Git and Build Process:
```bash
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo add-apt-repository 'deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-16 main'
sudo apt-get update
sudo apt-get install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential -y
sudo apt-get install -y libllvm-16-ocaml-dev libllvm16 llvm-16 llvm-16-dev llvm-16-doc llvm-16-examples llvm-16-runtime clang-16 clang-tools-16 clang-16-doc libclang-common-16-dev libclang-16-dev libclang1-16 clang-format-16 python3-clang-16 clangd-16 clang-tidy-16 libclang-rt-16-dev libpolly-16-dev libfuzzer-16-dev lldb-16 lld-16 libc++-16-dev libc++abi-16-dev libomp-16-dev libclc-16-dev libunwind-16-dev libmlir-16-dev mlir-16-tools flang-16 libclang-rt-16-dev-wasm32 libclang-rt-16-dev-wasm64 libclang-rt-16-dev-wasm32 libclang-rt-16-dev-wasm64
sudo ln -sf /usr/lib/llvm-16/bin/clang-16 /usr/bin/clang
sudo ln -sf /usr/lib/llvm-16/bin/clang++ /usr/bin/clang++

mkdir $HOME/opt && cd $HOME/opt
wget https://www.openssl.org/source/openssl-1.1.1o.tar.gz
tar -zxvf openssl-1.1.1o.tar.gz
cd openssl-1.1.1o
./config && make && make test
mkdir $HOME/opt/lib
mv $HOME/opt/openssl-1.1.1o/libcrypto.so.1.1 $HOME/opt/lib/
mv $HOME/opt/openssl-1.1.1o/libssl.so.1.1 $HOME/opt/lib/
export LD_LIBRARY_PATH=$HOME/opt/lib:$LD_LIBRARY_PATH
echo 'export LD_LIBRARY_PATH=$HOME/opt/lib:$LD_LIBRARY_PATH' >> ~/.bashrc

git clone https://github.com/simeononsecurity/CCminer-ARM-optimized.git
cd CCminer-ARM-optimized
chmod +x build.sh
chmod +x configure.sh
chmod +x autogen.sh
CXX=clang++ CC=clang ./build.sh
```
