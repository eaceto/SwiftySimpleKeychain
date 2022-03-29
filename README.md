# SwiftySimpleKeychain

A wrapper (written only in Swift) to make it really easy to deal with iOS, macOS, watchOS and Linux Keychain and store your user's credentials securely. Based on Auth0's SimpleKeychain (Thank you @Auth0!).

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
    - [Cocoapods](#cocoapods)
    - [Swifth Package Manager](#swift-package-manager)
- [Documentation](#documentation)

## Requirements

| Platform | Minimun Swift Version | Installation | Status |
| --- | --- | --- | -- |
| iOS 11.0+ | 5.3 | [Cocoapods](#cocoapods), [Swifth Package Manager](#swift-package-manager) | Fully Tested |
| macOS 10.12+ | 5.3 | [Cocoapods](#cocoapods), [Swifth Package Manager](#swift-package-manager) | Fully Tested | 
| tvOS 9.0+ | 5.3 | [Cocoapods](#cocoapods), [Swifth Package Manager](#swift-package-manager) | Fully Tested | 
| watchOS 5.0+ | 5.3 | [Cocoapods](#cocoapods), [Swifth Package Manager](#swift-package-manager) | Fully Tested | 
| Ubuntu 20.04+ | Latest Only | [Swifth Package Manager](#swift-package-manager) | Unsupported | 
| Windows | Latest Only | [Swifth Package Manager](#swift-package-manager) | Unsupported | 

## Installation

### Cocoapods

In your **Podfile** add the following line. **SwiftySimpleKeychain**. Where the latests version can be found on the project's GitHub Page.

```ruby
pod 'SwiftySimpleKeychain', '~> <<latest major version>>'
```

### Swift Package Manager

In your **Package.swift** add the following lines.

```swift
// Inside Package definition
dependencies: [
    .package(url: "https://github.com/eaceto/SwiftySimpleKeychain.git", .upToNextMajor("<<latest major version>>"))
]

// Inside Target definition
dependencies: [
    "SwiftySimpleKeychain"
]
```

## Documentation

Documentation of this library and its extensions is available in the project GitHub Page. [https://eaceto.github.io/SwiftySimpleKeychain](https://eaceto.github.io/SwiftySimpleKeychain).

Documentation includes not also [code documentation](https://eaceto.github.io/SwiftySimpleKeychain/), but also [code coverage](https://eaceto.github.io/SwiftySimpleKeychain/coverage/index.html) and [lint report](https://eaceto.github.io/SwiftySimpleKeychain/lint/index.html).