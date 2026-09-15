// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "OneSegStudio", platforms: [.macOS(.v14)], products: [.executable(name: "OneSegStudio", targets: ["OneSegStudio"])], targets: [.executableTarget(name: "OneSegStudio")])
