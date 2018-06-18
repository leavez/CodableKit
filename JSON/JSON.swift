//
//  JSON.swift
//  JSON
//
//  Created by 李孛 on 2018/6/15.
//

import Foundation

/// JSON value.
///
/// [https://json.org](https://json.org)
public enum JSON {
    case string(String)
    case number(NSNumber)
    case object([String: JSON])
    case array([JSON])
    case `true`
    case `false`
    case null
}
