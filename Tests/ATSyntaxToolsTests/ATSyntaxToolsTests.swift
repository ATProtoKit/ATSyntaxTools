//
//  ATSyntaxToolsTests.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2025-05-05.
//

import Testing
@testable import ATSyntaxTools

@Suite("Handle validation", .tags(.handles))
public struct HandleValidationTests {

    @Test("Accepts valid handles", arguments: TestCases.validHandles)
    public func acceptsValidHandles(_ handle: String) throws {
        try HandleValidator.validate(handle)
        #expect(HandleValidator.isValid(handle))
    }

    @Test("Rejects invalid handles", arguments: TestCases.invalidHandles)
    public func rejectsInvalidHandles(_ handle: String) {
        #expect(!HandleValidator.isValid(handle))
        #expect(throws: InvalidHandleError.self) {
            try HandleValidator.validate(handle)
        }
    }

    @Test("Normalizes handles to lowercase ASCII form")
    public func normalizesHandles() throws {
        let normalizedHandle = try HandleValidator.normalize("JoHn.TeST")
        #expect(normalizedHandle == "john.test")
    }
}
