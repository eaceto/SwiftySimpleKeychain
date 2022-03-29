---
id: getting_started
summary: Getting started with SwiftySimpleKeychain
categories: Documentation
status: Published
environments: web
authors: Ezequiel (Kimi) Aceto
feedback link: https://github.com/eaceto/SwiftySimpleKeychain
---

# Getting Started

## Adding the dependency
Duration: 0:00:30

Adding this library as dependency can be done using Cocoapods or Swift Package Manager.

### Cocoapods
In your **Podfile** add the following line to add **SwiftySimpleKeychain**. Where the latests version can be found on the project's GitHub Page.

```ruby
pod 'SwiftySimpleKeychain', '~> <<latest major version>>'
```

### Swift Package Manager

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

## Instantiating the wrapper
Duration: 0:00:30

Getting an instance of **SwiftySimpleKeychain** can be done either using:

```swift
let keychain = SwiftySimpleKeychain(with: "service-name")
```

or

```swift
let keychain = SwiftySimpleKeychain.with("service-name")
```

and optional **Access Group** can be specified when the keychain's entries needs to be accessed from another App / Target.

```swift
let keychain = SwiftySimpleKeychain.with("service-name", accessGroup: "my-group-identifier")
```

## Saving and retrieving items
Duration: 0:00:30

Saving a string, for example, can be easily done with:

```swift
_ = keychain.set(string: "a secret string", for: "aKey")
```

if you would like to know if saving the entry failed and why, 

```swift
let setResult = keychain.set(string: "a secret string", for: "aKey")
if case let .failure(error) = setResult {
    print(error)
}
return
```

Reading the stored value can be done as follows:

```swift
let value = keychain.string(for: "aKey")
```