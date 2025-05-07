//
//  TIDValidator.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2025-05-07.
//

import Foundation

/// Identifies and validates Timestamp Identifiers (TIDs).
public enum TIDValidator: ValidatorProtocol {

    /// Ensures the Timestamp Identifier (TID) is valid.
    ///
    /// - Parameter tid: The record key to be validated.
    ///
    /// - Throws: ``InvalidTIDError`` , indicating the Record Key is invalid.
    public static func validate(_ tid: String) throws {
        guard tid.count == 13 else {
            throw InvalidTIDError.invalidLength
        }

        let characterCheckFirstCharacter = CharacterSet(charactersIn: "234567abcdefghij")
        let characterCheckRemainingCharacters = CharacterSet(charactersIn: "234567abcdefghijklmnopqrstuvwxyz")

        if let firstCharacter = tid.first {
            let firstCharacterCheck = String(firstCharacter).rangeOfCharacter(from: characterCheckFirstCharacter.inverted) == nil
            let remainingCharacterCheck = String(tid.dropFirst()).rangeOfCharacter(from: characterCheckRemainingCharacters.inverted) == nil

            guard firstCharacterCheck && remainingCharacterCheck else {
                throw InvalidTIDError.invalidSyntax
            }
        }
    }

    /// Determines whether the Timestamp Identifier (TID) is valid.
    ///
    /// - Parameter tid: The Timestamp Identifier (TID) to validate.
    /// - Returns: `true` if the Timestamp Identifier (TID) is valid, or `false` if it isn't.
    public static func isValid(_ tid: String) -> Bool {
        do {
            try TIDValidator.validate(tid)
            return true
        } catch {
            return false
        }
    }
}
