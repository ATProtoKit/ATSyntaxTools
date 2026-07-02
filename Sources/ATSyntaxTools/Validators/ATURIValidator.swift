//
//  ATURIValidator.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2025-05-05.
//

import Foundation

/// Identifies and validates AT URIs.
public enum ATURIValidator: ValidatorProtocol {

    /// Ensures the AT URI is valid.
    ///
    /// - Parameter atURI: The AT URI to be validated.
    ///
    /// - Throws: ``InvalidATURIError``, indicating the AT URI is invalid.
    public static func validate(_ atURI: String) throws {
        guard atURI.count <= 8 * 1024 else {
            throw InvalidATURIError.tooLong
        }

        guard !atURI.contains("#") else {
            throw InvalidATURIError.fragmentPartNotAllowed
        }

        guard !atURI.contains("?") else {
            throw InvalidATURIError.queryPartNotAllowed
        }

        let asciiCheck = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._~:@!$&')(*+,;=%/-")

        guard atURI.rangeOfCharacter(from: asciiCheck.inverted) == nil else {
            throw InvalidATURIError.disallowedCharacters
        }

        let atURIFragments = atURI.components(separatedBy: "/")
        guard atURIFragments.count >= 3 else {
            throw InvalidATURIError.noMethodOrAuthorityParts
        }

        guard atURIFragments[0] == "at:", atURIFragments[1].isEmpty else {
            throw InvalidATURIError.noATPrefix
        }

        do {
            if atURIFragments[2].hasPrefix("did:") {
                _ = try DIDValidator.normalize(atURIFragments[2])
            } else {
                _ = try HandleValidator.normalize(atURIFragments[2])
            }
        } catch {
            throw InvalidATURIError.invalidHandleOrDIDInAuthorityPart
        }

        if atURIFragments.count >= 4 {
            guard atURIFragments[3].count > 0 else {
                throw InvalidATURIError.containsSlashAfterAuthoritySegmentWithoutPathSegment
            }

            do {
                try NSIDValidator.validate(atURIFragments[3])
            } catch {
                throw InvalidATURIError.invalidNSIDInFirstPathSegment
            }
        }

        if atURIFragments.count >= 5 {
            guard atURIFragments[4].count > 0 else {
                throw InvalidATURIError.containsSlashAfterCollectionWithNoRecordKey
            }

            do {
                try RecordKeyValidator.validate(atURIFragments[4])
            } catch {
                throw InvalidATURIError.invalidRecordKeyInSecondPathSegment
            }
        }

        guard atURIFragments.count < 6 else {
            throw InvalidATURIError.tooManyPathSegmentsAndOrHasTrailingSlash
        }
    }

    /// Determines whether the AT URI is valid.
    ///
    /// - Parameter atURI: The AT URI to validate.
    /// - Returns: `true` if the handle is valid, or `false` if it isn't.
    public static func isValid(_ atURI: String) -> Bool {
        do {
            try ATURIValidator.validate(atURI)
            return true
        } catch {
            return false
        }
    }
}
