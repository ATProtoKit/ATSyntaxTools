//
//  NSIDValidator.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2025-05-05.
//

import Foundation

/// Identifies and validates Namespace Identifiers (NSIDs).
public enum NSIDValidator: ValidatorProtocol {

    /// Ensures the Namespace Identifier (NSID) is valid.
    ///
    /// - Parameter nsid: The Namespace Identifier (NSID) to be validated.
    ///
    /// - Throws: ``InvalidNSIDError`` , indicating the Namespace Identifier (NSID) is invalid.
    public func validate(_ nsid: String) throws {
        let asciiCheck = CharacterSet.decimalDigits
            .union(.uppercaseLetters)
            .union(.lowercaseLetters)
            .union(CharacterSet(charactersIn: "._-"))

        guard nsid.rangeOfCharacter(from: asciiCheck.inverted) == nil else {
            throw InvalidHandleError.disallowedCharacter
        }

        let nsidCount = nsid.count
        guard nsidCount <= 317 else {
            throw InvalidNSIDError.tooLong(maxCharacters: 317)
        }

        let nsidComponents = nsid.split(separator: ".")
        guard nsidComponents.count >= 3 else {
            throw InvalidNSIDError.notEnoughSegments
        }

        for (index, nsidComponent) in nsidComponents.enumerated() {
            guard !nsidComponent.isEmpty else {
                throw InvalidNSIDError.nsidPartEmpty
            }

            guard nsidComponent.count <= 63 else {
                throw InvalidNSIDError.nsidPartTooLong(maxCharacters: nsidComponent.count)
            }

            guard !nsidComponent.hasPrefix("-"), !nsidComponent.hasSuffix("-") else {
                throw InvalidNSIDError.nsidPartStartsOrEndsWithHyphen
            }

            if index == 0,
               let firstCharacter = nsidComponent.first {
                let digitCheck = CharacterSet.decimalDigits
                guard String(firstCharacter).rangeOfCharacter(from: digitCheck.inverted) == nil else {
                    throw InvalidNSIDError.nsidPartStartsWithDigit
                }

                continue
            }

            if index == nsidComponents.count - 1,
               let firstCharacter = nsidComponent.first {
                let remainingCharacters = nsidComponent.dropFirst()

                let nameSegmentASCIICheckFirstCharacter = CharacterSet.uppercaseLetters
                    .union(.lowercaseLetters)
                let nameSegmentASCIICheck = nameSegmentASCIICheckFirstCharacter
                    .union(.decimalDigits)

                guard String(firstCharacter).rangeOfCharacter(from: nameSegmentASCIICheckFirstCharacter.inverted) == nil,
                      String(remainingCharacters).rangeOfCharacter(from: nameSegmentASCIICheck.inverted) == nil else {
                    throw InvalidNSIDError.nsidNamePartContainsInvalidCharacter
                }
            }
        }
    }

    /// Normalizes the Namespace Identifier (NSID).
    ///
    /// - Parameter nsid: The Namespace Identifier (NSID) to be normalized.
    /// - Returns: A normalized Namespace Identifier (NSID).
    ///
    /// - Throws: ``InvalidNSIDError``, indicating the Namespace Identifier (NSID) is invalid.
    public func normalize(_ nsid: String) throws -> String {
        <#code#>
    }
}
