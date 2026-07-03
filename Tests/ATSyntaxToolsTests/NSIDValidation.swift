//
//  NSIDValidation.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2026-07-03.
//

import Testing
@testable import ATSyntaxTools

@Suite("NSID validation", .tags(.nsids))
public struct NSIDValidationTests {

    @Test("Accepts valid NSIDs", arguments: TestCases.validNSIDs)
    public func acceptsValidNSIDs(_ nsid: String) throws {
        try NSIDValidator.validate(nsid)
        #expect(NSIDValidator.isValid(nsid))
    }

    @Test("Rejects invalid NSIDs", arguments: TestCases.invalidNSIDs)
    public func rejectsInvalidNSIDs(_ nsid: String) {
        #expect(!NSIDValidator.isValid(nsid))
        #expect(throws: InvalidNSIDError.self) {
            try NSIDValidator.validate(nsid)
        }
    }
}
