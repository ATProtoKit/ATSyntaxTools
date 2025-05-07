//
//  DIDValidator.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2025-05-05.
//

import Foundation

/// Identifies and validates decentralized identifiers (DIDs).
public enum DIDValidator: Canonicalizable {

    /// Ensures the decentralized identifier (DID) is valid.
    ///
    /// - Parameter did: The DID to be validated.
    ///
    /// - Throws: ``InvalidDIDError`` , indicating the DID is invalid.
    public func validate(_ did: String) throws {
        guard did.hasPrefix("did:") else {
            throw InvalidDIDError.noDIDPrefix
        }

        let asciiCheck = #"^[a-zA-Z0-9._:%-]*$"#
        guard RegexMatch.match(asciiCheck, in: did) != nil else {
            throw InvalidDIDError.disallowedCharacter
        }

        let segments = did.components(separatedBy: ":")
        guard segments.count >= 3 else {
            throw InvalidDIDError.missingDIDPrefixMethoOrIdentifier
        }

        let method = String(segments[1])
        let methodCheck = #"^[a-z]+$"#
        guard RegexMatch.match(methodCheck, in: method) != nil else {
            throw InvalidDIDError.didContainsUppercaseLetter
        }

        guard !did.hasSuffix(":"), !did.hasSuffix("%") else {
            throw InvalidDIDError.didEndsWithColonOrPercent
        }

        guard did.count <= 2_048 else {
            throw InvalidDIDError.didContainsUppercaseLetter
        }
    }

    /// Normalizes the decentralized identifier (DID).
    ///
    /// - Parameter did: The decentralized identifier (DID) to be normalized.
    /// - Returns: A normalized decentralized identifier (DID).
    ///
    /// - Throws: ``InvalidDIDError``, indicating the DID is invalid.
    public func normalize(_ did: String) throws -> String {
        let normalizedDID = did.lowercased()

        try self.validate(normalizedDID)
        return normalizedDID
    }
}
