# Development and packaging

The end-user DMG includes the runtime; development requires Xcode command-line tools and the exact locally installed dependency versions listed in runtime-components.json. build_app.sh compiles the SwiftUI application and copies its payload. If the bundled runtime is absent, bundle_runtime.py collects the installed Homebrew components, rewrites Mach-O dependencies and signs binaries ad hoc. This is a packaging recipe for the verified local environment, not a universal dependency installer.

```sh
sh build_app.sh
python3 test_portable.py
```

The test imports the signal-processing modules, checks the bundled HackRF plugin, generates a three-second sample and prepares its TS files. It uses an isolated HOME and PATH and checks the dynamic-loader log for Homebrew libraries. It never starts RF transmission.

Use build_dmg.sh after building the app to create the local DMG. Binaries belong in release assets rather than the source repository. Documentation video and download links remain pending until their URLs exist.

The Runtime is stored under Contents/Resources/Runtime. User-generated files go to ~/Library/Application Support/ONE SEG Studio. prepare.py instantiates the bundled pre-generated flowgraph template; GNU Radio Companion is not needed on the end-user computer.

The second-M1 result is reported by the author, not an automated compatibility matrix. The minimum system version remains macOS 26, as required by the bundled libraries.
