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
4) initialize submodules
```
git submodule init
git submodule update
```
5) build uniffi-bindgen
```
cd mee-core
$HOME/.cargo/bin/cargo build --bin mee_uniffi_bindgen
```
