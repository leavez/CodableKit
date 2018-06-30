# CodableKit

[![Build Status](https://travis-ci.org/kylinroc/CodableKit.svg?branch=master)](https://travis-ci.org/kylinroc/CodableKit)
[![codecov](https://codecov.io/gh/kylinroc/CodableKit/branch/master/graph/badge.svg)](https://codecov.io/gh/kylinroc/CodableKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Usage

### Shorthands

Sometimes we have to write `init(from:)` by hand, so let's make this work a little bit easier:

```swift
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    // self.name = try container.decode(String.self, forKey: .name)
    // Shorthand:
    self.name = try container.decode(.name)
    
    // self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
    // Shorthand:
    self.nickname = try container.decodeIfPresent(.nickname)
    
    // self.title = try? container.decode(String.self, forKey: .title)
    // Shorthand:
    self.title = container[.title]
}
```

### AnyCodingKey

When writing `init(from:)` by hand, we also have to write the annoying `CodingKeys`. So let's introducing `AnyCodingKey`, and forget about `CodingKeys`:

```swift
init(from decoder: Decoder) throws {
    let container = try decoder.container() // decoder.container(keyedBy: AnyCodingKey.self)
    
    self.name = try container.decode("name")
    self.nickname = try container.decoderIfPresent("nickname")
    self.title = container["title"]

    // Some tricks:
    self.camelCasePropertyWithDefaultValue 
        = container["camel_case_property_with_default_value"] ?? 42
}
```

### JSON

## Installation

### Carthage

```
github "kylinroc/CodableKit" ~> 1.0
```

### Swift Package Manager

```swift
import PackageDescription

let package = Package(
    name: "Example",
    dependencies: [
        .package(url: "https://github.com/kylinroc/CodableKit.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Example", dependencies: ["CodableKit"]),
    ]
)
```
