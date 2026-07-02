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

    @Test("Rejects handles that fail after normalization")
    public func rejectsInvalidNormalizedHandles() {
        #expect(throws: InvalidHandleError.self) {
            try HandleValidator.normalize("JoH!n.TeST")
        }
    }

    @Test("Reports disallowed TLDs")
    public func reportsDisallowedTLDs() {
        #expect(!HandleValidator.isTLDValid(handle: "laptop.local"))
        #expect(!HandleValidator.isTLDValid(handle: "name.onion"))
        #expect(HandleValidator.isTLDValid(handle: "alice.exampleapp"))
    }
}

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

@Suite("Record Key validation", .tags(.recordKeys))
public struct RecordKeyValidationTests {

    @Test("Accepts valid Record Keys", arguments: TestCases.validRecordKeys)
    public func acceptsValidRecordKeys(_ recordKey: String) throws {
        try RecordKeyValidator.validate(recordKey)
        #expect(RecordKeyValidator.isValid(recordKey))
    }
}
