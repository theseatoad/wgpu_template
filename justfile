# This requires rust toolchain. If CI/CI, need to install that first.
## Gets all deps
deps: install_trunk

## trunk and trunk dep
install_trunk:
    cargo install --locked trunk
    cargo install --locked wasm-bindgen-cli

## Builds
build_native:
    cargo build

build_web: install_trunk
    trunk build

## Run
native:
    cargo run

web: install_trunk
    trunk serve