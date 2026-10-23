#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p build
xcodebuild build \
  -project Thaw.xcodeproj -scheme Thaw -configuration Release \
  -destination 'platform=macOS,arch=arm64' \
  -derivedDataPath build/DerivedData \
  -clonedSourcePackagesDirPath build/SourcePackages \
  -disableAutomaticPackageResolution \
  ARCHS=arm64 ONLY_ACTIVE_ARCH=YES \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO \
  > build/release.log 2>&1

app="build/DerivedData/Build/Products/Release/NotchBar.app"
codesign --force --deep --sign - "$app"
codesign --verify --deep --strict --verbose=2 "$app"
echo "Built: $PWD/$app"

if [[ "${1:-}" == "--install" ]]; then
  if pgrep -f '/NotchBar.app/Contents/MacOS/NotchBar' >/dev/null; then
    echo 'Quit NotchBar before installing a new build.' >&2
    exit 1
  fi
  destination="$HOME/Applications/NotchBar.app"
  mkdir -p "$HOME/Applications"
  if [[ -e "$destination" ]]; then
    backup="build/NotchBar-backup-$(date +%Y%m%d-%H%M%S).app"
    ditto "$destination" "$backup"
  fi
  ditto "$app" "$destination"
  codesign --verify --deep --strict "$destination"
  echo "Installed: $destination"
fi
