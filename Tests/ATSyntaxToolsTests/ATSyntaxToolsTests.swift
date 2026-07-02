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
}
