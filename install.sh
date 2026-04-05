#!/usr/bin/env sh
set -eu

# oh-my-braincrew installer
# Usage: curl -fsSL https://raw.githubusercontent.com/teddynote-lab/oh-my-braincrew-release/main/install.sh | sh

REPO="teddynote-lab/oh-my-braincrew-release"
INSTALL_DIR="${OMB_INSTALL_DIR:-/usr/local/bin}"
BINARY_NAME="omb"

# --- Detect platform ---
detect_platform() {
  OS="$(uname -s)"
  ARCH="$(uname -m)"

  case "$OS" in
    Darwin)  PLATFORM="darwin" ;;
    Linux)   PLATFORM="linux" ;;
    *)       echo "Error: Unsupported OS: $OS" >&2; exit 1 ;;
  esac

  case "$ARCH" in
    x86_64|amd64)  ARCH="amd64" ;;
    arm64|aarch64) ARCH="arm64" ;;
    *)             echo "Error: Unsupported architecture: $ARCH" >&2; exit 1 ;;
  esac
}

# --- Fetch latest version ---
fetch_latest_version() {
  API_URL="https://api.github.com/repos/${REPO}/releases/latest"

  if command -v curl >/dev/null 2>&1; then
    RELEASE_JSON=$(curl -fsSL "$API_URL")
  elif command -v wget >/dev/null 2>&1; then
    RELEASE_JSON=$(wget -qO- "$API_URL")
  else
    echo "Error: curl or wget is required." >&2
    exit 1
  fi

  VERSION=$(echo "$RELEASE_JSON" | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"v\{0,1\}\([^"]*\)".*/\1/')
  if [ -z "$VERSION" ]; then
    echo "Error: Could not determine latest version." >&2
    exit 1
  fi
}

# --- Download and install ---
install() {
  ASSET_NAME="omb-v${VERSION}-${PLATFORM}-${ARCH}"
  DOWNLOAD_URL="https://github.com/${REPO}/releases/download/v${VERSION}/${ASSET_NAME}"

  echo "Installing omb v${VERSION} (${PLATFORM}/${ARCH})..."

  TMP_DIR=$(mktemp -d)
  TMP_FILE="${TMP_DIR}/${BINARY_NAME}"
  trap 'rm -rf "$TMP_DIR"' EXIT

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$TMP_FILE" "$DOWNLOAD_URL"
  else
    wget -qO "$TMP_FILE" "$DOWNLOAD_URL"
  fi

  chmod +x "$TMP_FILE"

  # Install to INSTALL_DIR (may need sudo)
  if [ -w "$INSTALL_DIR" ]; then
    mv "$TMP_FILE" "${INSTALL_DIR}/${BINARY_NAME}"
  else
    echo "Installing to ${INSTALL_DIR} (requires sudo)..."
    sudo mv "$TMP_FILE" "${INSTALL_DIR}/${BINARY_NAME}"
  fi

  echo ""
  echo "omb v${VERSION} installed to ${INSTALL_DIR}/${BINARY_NAME}"
  echo ""
  echo "Next steps:"
  echo "  1. Initialize in your project:  cd /path/to/project && omb init"
  echo "  2. Start Claude Code:           claude --plugin-dir ~/.omb/plugin"
  echo "  3. Run the setup wizard:        /omb setup"
  echo ""
  echo "Update anytime with:  omb update"
}

detect_platform
fetch_latest_version
install
