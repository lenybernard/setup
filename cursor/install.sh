#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
INSTALL_DIR="$HOME/Applications/cursor"
APPIMAGE_NAME="cursor.AppImage"
ICON_NAME="cursor.png"
APPIMAGE_PATH="$INSTALL_DIR/$APPIMAGE_NAME"
ICON_PATH="$INSTALL_DIR/$ICON_NAME"
DESKTOP_PATH="$HOME/.local/share/applications/cursor.desktop"
API_URL="https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable"
ICON_URL="https://us1.discourse-cdn.com/flex020/uploads/cursor1/original/2X/a/a4f78589d63edd61a2843306f8e11bad9590f0ca.png"
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64)"

echo "🚀 Installing Cursor AI IDE..."

# --- Ensure dependencies installed ---
for pkg in curl jq wget; do
    if ! command -v "$pkg" &>/dev/null; then
        echo "Missing dependency: $pkg. Installing..."
        sudo apt-get update
        sudo apt-get install -y "$pkg"
    fi
done

if ! ldconfig -p | grep -q libfuse.so.2; then
    echo "Missing dependency: libfuse2. Installing..."
    sudo apt-get update
    sudo apt-get install -y libfuse2
fi

# --- Fetch the dynamic latest AppImage URL with redirect follow ---
API_RESPONSE=$(curl -s -L -A "$USER_AGENT" "$API_URL")
DOWNLOAD_URL=$(echo "$API_RESPONSE" | jq -r '.downloadUrl' 2>/dev/null || echo "")

if [[ -z "$DOWNLOAD_URL" || "$DOWNLOAD_URL" == "null" ]]; then
    echo "❌ Failed to parse Cursor download URL from API."
    echo "API response was:"
    echo "$API_RESPONSE"
    exit 1
fi

echo "✅ Fetched download URL: $DOWNLOAD_URL"

# --- Create installation directory ---
mkdir -p "$INSTALL_DIR"

# --- Download Cursor AppImage ---
echo "📥 Downloading Cursor AppImage..."
curl -L -A "$USER_AGENT" "$DOWNLOAD_URL" -o "$APPIMAGE_PATH"
chmod +x "$APPIMAGE_PATH"

# --- Download icon ---
echo "🖼️ Copy icon..."
cp $ICON_NAME $ICON_PATH || echo "⚠️ Icon download failed; continuing."

# --- Create .desktop entry ---
mkdir -p "$(dirname "$DESKTOP_PATH")"
cat > "$DESKTOP_PATH" <<EOF
[Desktop Entry]
Name=Cursor AI IDE
Comment=AI-powered code editor
Exec=$APPIMAGE_PATH --no-sandbox %U
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Development;IDE;
StartupWMClass=Cursor
EOF

echo "✅ Created desktop entry at $DESKTOP_PATH"

# --- Update desktop database ---
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

# --- Add shell launcher function ---
for shellrc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$shellrc" ] && ! grep -q "^function cursor()" "$shellrc"; then
        cat >> "$shellrc" <<EOL

# Cursor AI IDE launcher
function cursor() {
  "$APPIMAGE_PATH" --no-sandbox "\$@" >/dev/null 2>&1 & disown
}
EOL
        echo "➕ Added 'cursor' shell function launcher to $shellrc"
    fi
done

echo ""
echo "🎉 Installation complete!"
echo " - Launch from your desktop menu: 'Cursor AI IDE'"
echo " - Or reload your shell and run: cursor"
echo ""
echo "To uninstall, run your cleanup script (if present)."
