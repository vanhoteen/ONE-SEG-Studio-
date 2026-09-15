#!/bin/sh
set -eu
PROJECT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
APP="$PROJECT/ONE SEG Studio.app"
DIST="$PROJECT/dist"
STAGE=$(mktemp -d "${TMPDIR:-/tmp}/oneseg-dmg.XXXXXX")
trap 'rm -rf "$STAGE"; rm -f "$STAGE.raw.dmg"' EXIT
mkdir -p "$DIST"
codesign --verify --deep --strict "$APP"
ditto "$APP" "$STAGE/ONE SEG Studio.app"
ln -s /Applications "$STAGE/Applications"
mkdir "$STAGE/Documentation"
cp "$PROJECT/README"*.md "$STAGE/Documentation/"
cp "$PROJECT/LICENSE-NOTICE.md" "$STAGE/Documentation/"
cp -R "$PROJECT/Assets" "$STAGE/Documentation/Assets"
cp -R "$PROJECT/docs" "$STAGE/Documentation/docs"
cat > "$STAGE/INSTALL.txt" <<'TXT'
ONE SEG Studio — vanhoteen

Drag ONE SEG Studio into Applications.
Arrastra ONE SEG Studio a Aplicaciones.

Apple Silicon (M1 or later) · macOS 26 or later
Interface: English / Español
Runtime included: no Homebrew, Python or Xcode installation required.
Ad-hoc signed; not Apple-notarized.

Video preparation does not transmit. Start transmission is a separate action.
TXT
hdiutil makehybrid -hfs -hfs-volume-name 'ONE SEG Studio' -o "$STAGE.raw.dmg" "$STAGE"
hdiutil convert -ov "$STAGE.raw.dmg" -format UDZO -o "$DIST/ONE-SEG-Studio-0.1-macOS-arm64.dmg"
rm -f "$STAGE.raw.dmg"
hdiutil verify "$DIST/ONE-SEG-Studio-0.1-macOS-arm64.dmg"
(cd "$DIST" && shasum -a 256 ONE-SEG-Studio-0.1-macOS-arm64.dmg > SHA256SUMS.txt)
