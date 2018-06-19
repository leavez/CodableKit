# JSON

```swift
let data: Data = ...
let json = try JSON.Serialization.json(with: data)
let model = JSON.Decoder().decode(Model.self, from: json)
```
