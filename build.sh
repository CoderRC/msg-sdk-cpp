#!/usr/bin/env bash

set -e

# ========= CONFIGURABLE =========
SRC_DIR="source"
BUILD_DIR="build"
INSTALL_DIR="install"

# ========= TOOL DETECTION & INSTALL =========

install_packages() {
    echo "Installing required packages..."

    REQUIRED_PACKAGES=("git" "gcc" "g++" "make" "autotools" "bison" "flex")

    if [[ "$(uname -o 2>/dev/null)" == "Msys" ]]; then
        echo "Detected MSYS2"
        for pkg in "${REQUIRED_PACKAGES[@]}"; do
            pacman -Sy --noconfirm "mingw-w64-x86_64-${pkg}" || pacman -Sy --noconfirm "${pkg}"
        done

    elif command -v apt &>/dev/null; then
        echo "Detected Debian/Ubuntu"
        sudo apt update
        sudo apt install -y "${REQUIRED_PACKAGES[@]}"

    elif command -v dnf &>/dev/null; then
        echo "Detected Fedora"
        sudo dnf install -y "${REQUIRED_PACKAGES[@]}"

    elif command -v yum &>/dev/null; then
        echo "Detected RHEL/CentOS"
        sudo yum install -y "${REQUIRED_PACKAGES[@]}"

    elif command -v zypper &>/dev/null; then
        echo "Detected openSUSE"
        sudo zypper install -y "${REQUIRED_PACKAGES[@]}"

    elif command -v a-g &>/dev/null; then
        echo "Detected a-g"
        for pkg in "${REQUIRED_PACKAGES[@]}"; do
            echo y | a-g install "a-g-install-${pkg}-using-source"
            echo y | a-g-install-${pkg}-using-source
        done

    else
        echo "Could not detect package manager. Please install manually: ${REQUIRED_PACKAGES[*]}"
        exit 1
    fi
}

check_and_install() {
    local tools=("git" "gcc" "g++" "make" "autoconf" "automake" "bison" "flex")
    local missing=()

    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &>/dev/null; then
            missing+=("$tool")
        fi
    done

    if (( ${#missing[@]} > 0 )); then
        echo "Missing tools: ${missing[*]}"
        install_packages
    fi
}

# ========= BUILD FUNCTIONS =========

create_build_dir() {
    mkdir -p "$BUILD_DIR"
}

compile_sources() {
    echo "Compiling sources..."
    cd build
    ../configure LDFLAGS=-lmingw32_extended
    make
}

run_tests() {
    echo "Running compiled tests..."
    make test
}

print_info() {
    echo "=============================="
    echo "  msg-sdk-cpp Build Script"
    echo "=============================="
    echo "Source:         $SRC_DIR"
    echo "Build Output:   $BUILD_DIR"
    echo "Install Prefix: $INSTALL_DIR (not used yet)"
    echo
}

# ========= MAIN =========

print_info
check_and_install
create_build_dir
compile_sources
run_tests

echo "Build and test complete!"