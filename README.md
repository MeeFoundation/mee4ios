# mee4ios
iOS Mee client

## Prerequisites

Steps for Mac OS
1) Install Rust https://www.rust-lang.org/learn/get-started
2) Use Rust latest stable toolchain
3) Install Rust targets
```
rustup target add x86_64-apple-ios
rustup target add aarch64-apple-ios
```
4) Install uniffi-bindgen
```
cargo install uniffi_bindgen@0.21.0
```
5) Install ndk version 21.4.7075529
6) add ndk bin to path
```
export ANDROID_NDK_HOME=/Users/User/Library/Android/sdk/ndk/21.4.7075529
export PATH=$PATH:$ANDROID_NDK_HOME/toolchains/x86_64-4.9/prebuilt/darwin-x86_64/bin:$ANDROID_NDK_HOME/toolchains/aarch64-linux-android-4.9/prebuilt/darwin-x86_64/bin

```
