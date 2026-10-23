#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build
xcodebuild test \
  -project Thaw.xcodeproj -scheme Thaw -configuration Debug \
  -destination 'platform=macOS,arch=arm64' \
  -derivedDataPath build/DerivedData \
  -clonedSourcePackagesDirPath build/SourcePackages \
  -disableAutomaticPackageResolution \
  -only-testing:ThawTests/UpdatesManagerTests \
  -only-testing:ThawTests/MenuBarItemServiceTests \
  -only-testing:ThawTests/MenuBarCaptureServiceTests \
  -only-testing:ThawTests/NotchBarDefaultsTests \
  -only-testing:ThawTests/HotkeysSettingsPersistenceTests \
  -only-testing:ThawTests/DisplaySettingsManagerGlobalFallbackTests \
  -resultBundlePath "build/NotchBar-tests-$(date +%Y%m%d-%H%M%S).xcresult" \
  ARCHS=arm64 ONLY_ACTIVE_ARCH=YES \
  CODE_SIGN_IDENTITY='-' CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM='' \
  > build/tests.log 2>&1
echo 'Passed: NotchBar defaults, hotkey persistence, display fallback regression tests.'
