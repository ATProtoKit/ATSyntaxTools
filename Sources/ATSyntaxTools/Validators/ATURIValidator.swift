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
        let uriParts = atURI.components(separatedBy: "#")

        guard uriParts.count <= 2 else {
            throw InvalidATURIError.invalidNumberOfPartsWithTrailingSlash
        }

        let asciiCheck = CharacterSet.lowercaseLetters
            .union(.uppercaseLetters)
            .union(.decimalDigits)
            .union(CharacterSet(charactersIn: "._~:@!$&')(*+,;=%/-"))

        guard let fragmentSegment = uriParts.last,
              let uriPart = uriParts.first,
              String(uriPart).rangeOfCharacter(from: asciiCheck.inverted) == nil else {
            throw InvalidATURIError.disallowedCharacters
        }

        let atURIFragments = String(uriPart).components(separatedBy: "/")
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
        }

        guard atURIFragments.count < 6 else {
            throw InvalidATURIError.tooManyPathSegmentsAndOrHasTrailingSlash
        }

        if uriParts.count == 2 {
            guard !fragmentSegment.isEmpty else {
                throw InvalidATURIError.emptyFragmentPartWithSlashAtTheStart
            }

            guard fragmentSegment.first == "/" else {
                throw InvalidATURIError.emptyFragmentPartWithSlashAtTheStart
            }

            let fragmentCheck = CharacterSet.uppercaseLetters
                .union(.lowercaseLetters)
                .union(.decimalDigits)
                .union(CharacterSet(charactersIn: #"._~:@!$&')(*+,;=%[]/-"#))

            let hasValidFragmentPrefix = fragmentSegment.first == "/"
            let fragmentHasOnlyAllowedCharacters = fragmentSegment.rangeOfCharacter(from: fragmentCheck.inverted) == nil

            guard hasValidFragmentPrefix && fragmentHasOnlyAllowedCharacters else {
                throw InvalidATURIError.disallowedCharactersInFragmentSegment
            }
        }

        guard atURI.count <= 8 * 1024 else {
            throw InvalidATURIError.tooLong
        }
    }
}
