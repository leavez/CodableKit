# JSON

## Decoding

```swift
struct Model: Codable {
    let string: String
    let number: Int
    let array: [Int]
}

// Decode Data.

let data = """
    {
        "string": "string",
        "number": 42,
        "array": [0, 1, 2, 3]
    }
    """
    .data(using: .utf8)!

let model = try! JSON.Decoder().decode(Model.self, from: data)

// Decode JSON object.

let jsonObject = try! JSON.Serialization.jsonObject(with: data)
let json = JSON(jsonObject)!

let model = try! JSON.Decoder().decode(Model.self, from: json)
```
