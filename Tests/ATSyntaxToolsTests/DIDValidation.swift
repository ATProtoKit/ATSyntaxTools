//
//  DIDValidation.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2026-07-03.
//

import Testing
@testable import ATSyntaxTools

@Suite("DID validation", .tags(.dids))
public struct DIDValidationTests {

    @Test("Accepts valid DIDs", arguments: TestCases.validDIDs)
    public func acceptsValidDIDs(_ did: String) throws {
        try DIDValidator.validate(did)
        #expect(DIDValidator.isValid(did))
    }

    @Test("Rejects invalid DIDs", arguments: TestCases.invalidDIDs)
    public func rejectsInvalidDIDs(_ did: String) {
        #expect(!DIDValidator.isValid(did))
        #expect(throws: InvalidDIDError.self) {
            try DIDValidator.validate(did)
        }
    }

    @Test("Preserves case-sensitive DID during normalization")
    public func preservesCaseSensitiveDIDs() throws {
        let did = "did:key:zQ3shZc2QzApp2oymGvQbzP8eKheVshBHbU4ZYjeXqwSKEn6N"
        let normalizedDID = try DIDValidator.normalize(did)
        #expect(normalizedDID == did)
    }
}
