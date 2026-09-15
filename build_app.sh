#!/bin/sh
set -eu
PROJECT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
APP="$PROJECT/ONE SEG Studio.app"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" "$PROJECT/.build/module-cache"
xcrun swiftc -parse-as-library -module-cache-path "$PROJECT/.build/module-cache" "$PROJECT/Sources/OneSegStudio/"*.swift -o "$APP/Contents/MacOS/OneSegStudio"
cp "$PROJECT/Assets/one-seg-logo.png" "$APP/Contents/Resources/one-seg-logo.png"
cp "$PROJECT/Assets/app-icon.png" "$APP/Contents/Resources/app-icon.png"
for SCRIPT in prepare.py detect_hackrf.py signal_tx.py; do
    cp "$PROJECT/$SCRIPT" "$APP/Contents/Resources/$SCRIPT"
done
if [ ! -f "$APP/Contents/Resources/Runtime/manifest.json" ]; then
    /usr/bin/python3 "$PROJECT/bundle_runtime.py"
fi
cp -R "$PROJECT/Payload" "$APP/Contents/Resources/"
ICONSET="$PROJECT/.build/Studio.iconset"
mkdir -p "$ICONSET"
for SIZE in 16 32 128 256 512; do
    sips -z "$SIZE" "$SIZE" "$PROJECT/Assets/app-icon.png" --out "$ICONSET/icon_${SIZE}x${SIZE}.png" >/dev/null
    DOUBLE=$((SIZE * 2))
    sips -z "$DOUBLE" "$DOUBLE" "$PROJECT/Assets/app-icon.png" --out "$ICONSET/icon_${SIZE}x${SIZE}@2x.png" >/dev/null
done
/usr/bin/python3 "$PROJECT/package_icon.py" "$ICONSET" "$APP/Contents/Resources/Studio.icns"
cp "$PROJECT/Info.plist" "$APP/Contents/Info.plist"
codesign --force --sign - "$APP"
