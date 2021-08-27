//
//  AnyEncodable.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 25/08/2021.
//

import Foundation

struct AnyEncodable: Encodable {
    let value: Any
    
    init<T>(_ value: T?) {
        self.value = value ?? ()
    }
}

extension AnyEncodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
            case is Void:
                try container.encodeNil()
            case let bool as Bool:
                try container.encode(bool)
            case let int as Int:
                try container.encode(int)
            case let string as String:
                try container.encode(string)
            case let array as [Any?]:
                try container.encode(array.map { AnyEncodable($0) })
            case let dictionary as [String: Any?]:
                try container.encode(dictionary.mapValues { AnyEncodable($0) })
            default:
                throw EncodingError.invalidValue(
                    value,
                    .init(
                        codingPath: container.codingPath,
                        debugDescription: "Encoding for this value is not implemented"
                    )
                )
        }
    }
}

extension AnyEncodable: ExpressibleByNilLiteral {
    init(nilLiteral: ()) {
        self.value = ()
    }
}

extension AnyEncodable: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: BooleanLiteralType) {
        self.value = value
    }
}

extension AnyEncodable: ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        self.value = value
    }
}

extension AnyEncodable: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        self.value = value
    }
}

extension AnyEncodable: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = Any
    
    init(arrayLiteral elements: ArrayLiteralElement...) {
        self.value = elements
    }
}

extension AnyEncodable: ExpressibleByDictionaryLiteral {
    typealias Key = AnyHashable
    
    typealias Value = Any
    
    init(dictionaryLiteral elements: (Key, Value)...) {
        self.value = elements
    }
}
