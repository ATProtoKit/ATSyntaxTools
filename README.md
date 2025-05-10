<p align="center">
  <img src="https://github.com/ATProtoKit/ATSyntaxTools/blob/main/Sources/ATSyntaxTools/Documentation.docc/Resources/atsyntaxtools_icon.png" height="128" alt="An icon for ATSyntaxTools, which contains three stacks of rounded rectangles in an isometric top view. At the top stack, there's an at symbol in a thick weight, with a pointed arrow at the tip. On the left and right side, there are left and right curly braces in a thick weight. Behind the at symbol is a faded slash. The three stacks are, from top to bottom, green, teal, and blue.">
</p>

<h1 align="center">ATSyntaxTools</h1>

<p align="center">Syntax validators for the AT Protocol, written in Swift.</p>

<div align="center">

[![GitHub Repo stars](https://img.shields.io/github/stars/atprotokit/atsyntaxtools?style=flat&logo=github)](https://github.com/ATProtoKit/ATSyntaxTools)

</div>
<div align="center">

[![Static Badge](https://img.shields.io/badge/Follow-%40cjrriley.com-0073fa?style=flat&logo=bluesky&labelColor=%23151e27&link=https%3A%2F%2Fbsky.app%2Fprofile%2Fcjrriley.com)](https://bsky.app/profile/cjrriley.com)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/masterj93?color=%23cb5f96&link=https%3A%2F%2Fgithub.com%2Fsponsors%2FMasterJ93)](https://github.com/sponsors/MasterJ93)

</div>

ATSyntaxTools is a lightweight Swift library for handling validations for various identifiers within the AT Protocol. It's fast, simple, and leaves an extremely small footprint in your project. This package is designed to ensure that you're not passing the wrong infroamtion that could cause your project to crash.

This Swift package mainly focuses on the syntax validation side of the AT Protocol. This is based on the [`syntax`](https://github.com/bluesky-social/atproto/tree/main/packages/syntax) package from the official [`atproto`](https://github.com/bluesky-social/atproto) TypeScript repository.

## Quick Examples

Here are the following identifiers for you to use in this package.

### Handles

```swift
import ATSyntaxTools

do {
    let isHandleValid = HandleValidator.isHandleValid("alice.test")
    print(isHandleValid) // returns `true`.

    try HandleValidator.validate("alice.test") // Doesn't throw; handle is valid.

    let isHandleValid2 = HandleValidator.isHandleValid("al!ce.test")
    print(isHandleValid2) // returns `false`.

    try HandleValidator.validate("al!ce.test") // Throws InvalidHandleError.
} catch {
    print(error)
}
```

### Decentralized Identifier (DID)

```swift
import ATSyntaxTools

do {
    try DIDValidator.validate("did:method:val") // Doesn't throw; DID is valid.
    try DIDValidator.validate(":did:method:val") // Throws InvalidDIDError.
} catch {
    print(error)
}
```

### Namespaced Identifier (NSID)

```swift
import ATSyntaxTools

do {
    try NSIDValidator.validate("com.example.foo") // Doesn't throw; NSID is valid.
    try NSIDValidator.validate("com.example.someRecord") // Doesn't throw; NSID is valid.
    try NSIDValidator.validate("example.com/foo") // Throws InvalidNSIDError.
    try NSIDValidator.validate("foo") // Throws InvalidNSIDError.
} catch {
    print(error)
}
```

### AT URIs

```swift
import ATSyntaxTools

do {
    try ATURIValidator.validate("at://bob.com/com.example.post/1234") // Doesn't throw; AT URI is valid.
    try ATURIValidator.validate("at:://bob.com/com.examp!e.2/1234") // Throws InvalidATURIError
} catch {
    print(error)
}
```

## Installation
You can use the Swift Package Manager to download and import the library into your project:
```swift
dependencies: [
    .package(url: "https://github.com/ATProtoKit/ATSyntaxTools.git", from: "0.1.0")
]
```

Then under `targets`:
```swift
targets: [
    .target(
        // name: "[name of target]",
        dependencies: [
            .product(name: "ATSyntaxTools", package: "atsyntaxtools")
        ]
    )
]
```

## Requirements
To use ATProtoKit in your apps, your app should target the specific version numbers:
- **iOS** and **iPadOS** 14 or later.
- **macOS** 13 or later.
- **tvOS** 14 or later.
- **visionOS** 1 or later.
- **watchOS** 9 or later.

For Linux, you need to use Swift 6.0 or later. On Linux, the minimum requirements include:
- **Amazon Linux** 2
- **Debian** 12
- **Fedora** 39
- **Red Hat UBI** 9
- **Ubuntu** 20.04

You can also use this project for any programs you make using Swift and running on **Docker**.

> [!WARNING]
> As of right now, Windows support is theoretically possible, but not has not been tested to work. Contributions and feedback on making it fully compatible for Windows and Windows Server are welcomed.

## Submitting Contributions and Feedback
While this project will change significantly, feedback, issues, and contributions are highly welcomed and encouraged. If you'd like to contribute to this project, please be sure to read both the [API Guidelines](https://github.com/ATProtoKit/ATSyntaxTools/blob/main/API_GUIDELINES.md) as well as the [Contributor Guidelines](https://github.com/MasterJ93/ATProtoKit/blob/main/CONTRIBUTING.md) before submitting a pull request. Any issues (such as bug reports or feedback) can be submitted in the [Issues](https://github.com/ATProtoKit/ATSyntaxTools/issues) tab. Finally, if there are any security vulnerabilities, please read [SECURITY.md](https://github.com/ATProtoKit/ATSyntaxTools/blob/main/SECURITY.md) for how to report it.

If you have any questions, you can ask me on Bluesky ([@cjrriley.com](https://bsky.app/profile/cjrriley.com)). And while you're at it, give me a follow! I'm also active on the [Bluesky API Touchers](https://discord.gg/3srmDsHSZJ) Discord server.

## License
This Swift package is using the Apache 2.0 License. Please view [LICENSE.md](https://github.com/ATProtoKit/ATSyntaxTools/blob/main/LICENSE.md) for more details.
