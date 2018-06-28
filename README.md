# CodableKit

## Usage

### Shorthands

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

## Integration
