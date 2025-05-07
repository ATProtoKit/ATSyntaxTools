//
//  RecordKeyValidator.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2025-05-05.
//

import Foundation

/// Identifies and validates Record Keys.
public enum RecordKeyValidator: ValidatorProtocol {

    /// Ensures the Record Key is valid.
    ///
    /// - Parameter recordKey: The record key to be validated.
    ///
    /// - Throws: ``InvalidRecordKeyError`` , indicating the Record Key is invalid.
    public static func validate(_ recordKey: String) throws {
        guard recordKey.count > 1, recordKey.count <= 512 else {
            throw InvalidRecordKeyError.invalidLength
        }

        let characterCheck = CharacterSet.decimalDigits
            .union(.uppercaseLetters)
            .union(.lowercaseLetters)
            .union(CharacterSet(charactersIn: "_~.:-"))

        guard recordKey.rangeOfCharacter(from: characterCheck.inverted) == nil else {
            throw InvalidRecordKeyError.invalidSyntax
        }

        guard recordKey != ".", recordKey != ".." else {
            throw InvalidRecordKeyError.onlyContainsPeriods
        }
    }

    /// Determines whether the Record Key is valid.
    ///
    /// - Parameter recordKey: The Record Key to validate.
    /// - Returns: `true` if the Record Key is valid, or `false` if it isn't.
    public static func isValid(_ recordKey: String) -> Bool {
        do {
            try RecordKeyValidator.validate(recordKey)
            return true
        } catch {
            return false
        }
    }
}
