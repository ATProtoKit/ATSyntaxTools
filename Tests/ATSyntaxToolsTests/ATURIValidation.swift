//
//  ATURIValidation.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2026-07-03.
//

import Testing
@testable import ATSyntaxTools

@Suite("AT URI validation", .tags(.atURIs))
public struct ATURIValidationTests {

    @Test("Accepts valid restricted AT URIs", arguments: TestCases.validATURIs)
    public func acceptsValidATURIs(_ atURI: String) throws {
        try ATURIValidator.validate(atURI)
        #expect(ATURIValidator.isValid(atURI))
    }

    @Test("Rejects invalid restricted AT URIs", arguments: TestCases.invalidATURIs)
    public func rejectsInvalidATURIs(_ atURI: String) {
        #expect(!ATURIValidator.isValid(atURI))
        #expect(throws: InvalidATURIError.self) {
            try ATURIValidator.validate(atURI)
        }
    }
}
