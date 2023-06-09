//
//  Sequence+acyncReduce.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 8.6.23..
//

import Foundation

public extension Sequence {
    func asyncReduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: ((Result, Element) async throws -> Result)
    ) async rethrows -> Result {
        var result = initialResult
        for element in self {
            result = try await nextPartialResult(result, element)
        }
        return result
    }
}

public extension Sequence {
    func asyncFilter(
        _ shouldBePresentInFinalArray: ((Self.Element) async throws -> Bool)
    ) async rethrows -> [Self.Element] {
        var result = [Self.Element]()
        for element in self {
            let positive = try await shouldBePresentInFinalArray(element)
            if positive {
                result.append(element)
            }
        }
        return result
    }
}
