//
//  String+SnakeCased.swift
//  JSON
//
//  Created by 李孛 on 2018/6/24.
//

private let uppercaseLetters: ClosedRange<Character> = "A"..."Z"

extension Character {
    fileprivate var isUppercase: Bool {
        return uppercaseLetters.contains(self)
    }
}

extension String {
    func snakeCased() -> String {
        guard !self.contains("_") else {
            return self
        }
        var words: [String] = []
        var word = ""
        let characters = Array(self)
        for (index, c) in characters.enumerated() {
            let isEndOfLowercaseWord = c.isUppercase && word.last?.isUppercase == false
            let isEndOfUppercaseWord
                = c.isUppercase && index + 1 < characters.count && !characters[index + 1].isUppercase
            if isEndOfLowercaseWord || isEndOfUppercaseWord {
                words.append(word)
                word = String(c)
            } else {
                word.append(c)
            }
        }
        if !word.isEmpty {
            words.append(word)
        }
        return words.map({ $0.lowercased() }).joined(separator: "_")
    }
}
