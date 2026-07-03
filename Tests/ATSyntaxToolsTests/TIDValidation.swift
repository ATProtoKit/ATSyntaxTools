//
//  TIDValidation.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2026-07-03.
//

import Testing
@testable import ATSyntaxTools

@Suite("TID validation", .tags(.tids))
public struct TIDValidationTests {

    @Test("Accepts valid TIDs", arguments: TestCases.validTIDs)
    public func acceptsValidTIDs(_ tid: String) throws {
        try TIDValidator.validate(tid)
        #expect(TIDValidator.isValid(tid))
    }

    @Test("Rejects invalid TIDs", arguments: TestCases.invalidTIDs)
    public func rejectsInvalidTIDs(_ tid: String) {
        #expect(!TIDValidator.isValid(tid))
        #expect(throws: InvalidTIDError.self) {
            try TIDValidator.validate(tid)
        }
    }
}
