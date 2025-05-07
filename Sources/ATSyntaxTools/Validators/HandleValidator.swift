//
//  HandleValidator.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2025-05-05.
//

import Foundation

/// Identifies and validates handles.
public enum HandleValidator: Canonicalizable {

    /// A string representation of an invalid handle.
    public static let invalidHandle: String = "handle.invalid"

    /// An array of invalid TLDs.
    ///
    /// - Note: Currently, `.onion` is in the array. The AT Protocol may change this at a later date.
    public static let disallowedTLDs: [String] = {
        var tlds = [
            ".local",
            ".arpa",
            ".invalid",
            ".localhost",
            ".internal",
            ".example",
            ".alt",
            ".onion"
        ]
        #if DEBUG
        tlds.append(".test")
        #endif
        return tlds
    }()

    /// Ensures the handle is valid.
    ///
    /// - Parameter handle: The handle to be validated.
    ///
    /// - Throws: ``InvalidHandleError``, indicating the handle is invalid.
    public static func validate(_ handle: String) throws {
        guard handle != HandleValidator.invalidHandle else {
            throw InvalidHandleError.handleIsInvalidHandle
        }

        let asciiCheck = CharacterSet.decimalDigits
                         .union(.uppercaseLetters)
                         .union(.lowercaseLetters)
                         .union(CharacterSet(charactersIn: "._-"))

        guard handle.rangeOfCharacter(from: asciiCheck.inverted) == nil else {
            throw InvalidHandleError.disallowedCharacter
        }

        let handleCount = handle.count
        guard handleCount <= 253 else {
            throw InvalidHandleError.tooLong(maxCharacters: handleCount)
        }

        let handleComponents = handle.components(separatedBy: ".")
        guard handleComponents.count >= 2 else {
            throw InvalidHandleError.handleDomainHasLessThanTwoParts
        }

        for (index, handleComponent) in handleComponents.enumerated() {
            guard !handleComponent.isEmpty else {
                throw InvalidHandleError.handlePartsEmpty
            }

            guard handleComponent.count <= 63 else {
                throw InvalidHandleError.handlePartTooLong
            }

            guard !handleComponent.hasPrefix("-"), !handleComponent.hasSuffix("-") else {
                throw InvalidHandleError.handlePartStartsOrEndsWithHyphen
            }

            if index == handleComponents.count - 1,
               let firstCharacter = handleComponent.first {
                let tldASCIICheck = CharacterSet.uppercaseLetters
                    .union(.lowercaseLetters)

                guard String(firstCharacter).rangeOfCharacter(from: tldASCIICheck.inverted) == nil else {
                    throw InvalidHandleError.tldPartBeginsWithNonASCIILetter
                }
            }
        }
    }

    /// Normalizes the handle.
    ///
    /// - Parameter handle: The handle to be normalized.
    /// - Returns: A normalized handle.
    ///
    /// - Throws: ``InvalidHandleError``, indicating the handle is invalid.
    public static func normalize(_ handle: String) throws -> String {
        let normalizedHandle = handle.lowercased()
        try HandleValidator.validate(normalizedHandle)

        return normalizedHandle
    }

    /// Determines whether the handle is valid.
    ///
    /// - Parameter handle: The handle to validate.
    /// - Returns: `true` if the handle is valid, or `false` if it isn't.
    public static func isHandleValid(_ handle: String) -> Bool {
        do {
            try HandleValidator.validate(handle.lowercased())
            return true
        } catch {
            return false
        }
    }

    /// Determines whether the TLD is valid.
    ///
    /// - Parameter handle: The handle that contains the TLD.
    /// - Returns: `true` if the TLD is valid, or `false` if it isn't.
    public static func isTLDValid(handle: String) -> Bool {
        let handleComponents = handle.lowercased().components(separatedBy: ".")

        guard let handleComponent = handleComponents.last else {
            return false
        }

        let tld = ".\(handleComponent)"
        return HandleValidator.disallowedTLDs.contains(tld)
    }

}
