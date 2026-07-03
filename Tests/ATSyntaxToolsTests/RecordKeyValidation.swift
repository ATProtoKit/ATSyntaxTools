//
//  RecordKeyValidation.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2026-07-03.
//

import Testing
@testable import ATSyntaxTools

@Suite("Record Key validation", .tags(.recordKeys))
public struct RecordKeyValidationTests {

    @Test("Accepts valid Record Keys", arguments: TestCases.validRecordKeys)
    public func acceptsValidRecordKeys(_ recordKey: String) throws {
        try RecordKeyValidator.validate(recordKey)
        #expect(RecordKeyValidator.isValid(recordKey))
    }

    @Test("Rejects invalid Record Keys", arguments: TestCases.invalidRecordKeys)
    public func rejectsInvalidRecordKeys(_ recordKey: String) {
        #expect(!RecordKeyValidator.isValid(recordKey))
        #expect(throws: InvalidRecordKeyError.self) {
            try RecordKeyValidator.validate(recordKey)
        }
    }
}
