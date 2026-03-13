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
    /// - Throws: ``InvalidNSIDError``, indicating the Namespace Identifier (NSID) is invalid.
    public static func validate(_ nsid: String) throws {
        let allowedASCIICharacterSet = CharacterSet.decimalDigits
            .union(.uppercaseLetters)
            .union(.lowercaseLetters)
            .union(CharacterSet(charactersIn: "._-"))

        guard nsid.rangeOfCharacter(from: allowedASCIICharacterSet.inverted) == nil else {
            throw InvalidNSIDError.disallowedCharacter
        }

        let nsidCharacterCount = nsid.count
        guard nsidCharacterCount <= 317 else {
            throw InvalidNSIDError.tooLong(maxCharacters: 317)
        }

        let nsidComponents = nsid.components(separatedBy: ".")
        guard nsidComponents.count >= 3 else {
            throw InvalidNSIDError.notEnoughSegments
        }

        for (index, nsidComponent) in nsidComponents.enumerated() {
            guard !nsidComponent.isEmpty else {
                throw InvalidNSIDError.nsidPartEmpty
            }

            guard nsidComponent.count <= 63 else {
                throw InvalidNSIDError.nsidPartTooLong(maxCharacters: 63)
            }

            guard !nsidComponent.hasPrefix("-"), !nsidComponent.hasSuffix("-") else {
                throw InvalidNSIDError.nsidPartStartsOrEndsWithHyphen
            }

            if index == 0,
               let firstCharacter = nsidComponent.first {
                let digitCharacterSet = CharacterSet.decimalDigits

                guard String(firstCharacter).rangeOfCharacter(from: digitCharacterSet) == nil else {
                    throw InvalidNSIDError.nsidPartStartsWithDigit
                }

                continue
            }

            if index == nsidComponents.count - 1,
               let firstCharacter = nsidComponent.first {
                let remainingCharacters = nsidComponent.dropFirst()

                let firstCharacterAllowedSet = CharacterSet.uppercaseLetters
                    .union(.lowercaseLetters)

                let remainingCharactersAllowedSet = firstCharacterAllowedSet
                    .union(.decimalDigits)

                guard String(firstCharacter).rangeOfCharacter(from: firstCharacterAllowedSet.inverted) == nil,
                      String(remainingCharacters).rangeOfCharacter(from: remainingCharactersAllowedSet.inverted) == nil else {
                    throw InvalidNSIDError.nsidNamePartContainsInvalidCharacter
                }
            }
        }
    }

    /// Determines whether the Namespaced Identifier (NSID) is valid.
    ///
    /// - Parameter nsid: The Namespaced Identifier (NSID) to validate.
    /// - Returns: `true` if the Namespaced Identifier (NSID) is valid, or `false` if it isn't.
    public static func isValid(_ nsid: String) -> Bool {
        do {
            try NSIDValidator.validate(nsid)
            return true
        } catch {
            return false
        }
    }
}
