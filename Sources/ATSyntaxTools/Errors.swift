//
//  Errors.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2025-05-05.
//

import Foundation

/// Represents errors related to invalid decentralized identifiers (DID).
public enum InvalidDIDError: Error, LocalizedError, CustomStringConvertible {

    /// Decentralized identifier (DIDs) didn't start with `did:`.
    case noDIDPrefix

    /// Decentralized identifier (DID) has at least one invalid character.
    case disallowedCharacter

    /// Decentralized identifier (DID) is missing the `did:` prefix, method, or identifier.
    case missingDIDPrefixMethoOrIdentifier

    /// Decentralized identifier (DID) has an uppercase character.
    case didContainsUppercaseLetter

    /// Decentralized identifier (DID) is ending with either a colon or percent sign.
    case didEndsWithColonOrPercent

    /// Decentralized identifier (DID) is too long.
    case tooLong

    /// Decentralized identifier (DID) couldn't be validated using a regular expression.
    case didntValidateViaRegex

    public var errorDescription: String? {
        switch self {
            case .noDIDPrefix:
                return "DID must start with 'did:'."
            case .disallowedCharacter:
                return "Invalid character in DID. DID should only include ASCII characters, numbers, '-', '_', '.', '+', and '/'."
            case .missingDIDPrefixMethoOrIdentifier:
                return "DID must start with 'did:' followed by a method and method specific content."
            case .didContainsUppercaseLetter:
                return "DID method must consist of lowercase letters."
            case .didEndsWithColonOrPercent:
                return "DID cannot end with a ':' or '%'."
            case .tooLong:
                return "DID is too long. The maximum length is 2,048 characters."
            case .didntValidateViaRegex:
                return "DID did not validate via regular expression."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}

/// Represents errors related to invalid handles.
public enum InvalidHandleError: Error, LocalizedError, CustomStringConvertible {

    /// Handle is literally named `invalid.handle`.
    case handleIsInvalidHandle

    /// Handle has at least one invalid character.
    case disallowedCharacter

    /// Handle is too long.
    ///
    /// - Parameter maxCharacters: The maximum number of characters a handle can have.
    case tooLong(maxCharacters: Int)

    /// Handle domain has less than two parts.
    case handleDomainHasLessThanTwoParts

    /// Handle parts don't contain any characters.
    case handlePartsEmpty

    /// At least one part of the handle is too long.
    case handlePartTooLong

    /// At least one part of the handle begins with, or ends with, a hyphen.
    case handlePartStartsOrEndsWithHyphen

    /// The TLD portion of the handle contains a non-ASCII letter.
    case tldPartBeginsWithNonASCIILetter

    /// Handle couldn't be validated using a regular expression.
    case didntValidateViaRegex


    public var errorDescription: String? {
        switch self {
            case .handleIsInvalidHandle:
                return "Handle is literally named \"invalid.handle\"."
            case .disallowedCharacter:
                return "Handle has at least one invalid character."
            case .tooLong(let maxCharacters):
                return "Handle is too long. Maximum \(maxCharacters) characters."
            case .handleDomainHasLessThanTwoParts:
                return "Handle domain has less than two parts."
            case .handlePartsEmpty:
                return "Handle parts don't contain any characters."
            case .handlePartTooLong:
                return "At least one part of the handle is too long."
            case .handlePartStartsOrEndsWithHyphen:
                return "At least one part of the handle begins with, or ends with, a hyphen."
            case .tldPartBeginsWithNonASCIILetter:
                return "The TLD portion of the handle must begin with an ASCII letter."
            case .didntValidateViaRegex:
                return "Handle didn't validate via regular expression."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}

/// Represents errors related to reserved handles.
public enum ReservedHandleError: Error, LocalizedError, CustomStringConvertible {

    /// Handle is already reserved.
    case alreadyReserved

    public var errorDescription: String? {
        switch self {
            case .alreadyReserved:
                return "Handle is already reserved."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}

/// Represents errors related to unsupported domains.
public enum UnsupportedDomainError: Error, LocalizedError, CustomStringConvertible {

    /// Handle domain is unsupported.
    case unsupported

    public var errorDescription: String? {
        switch self {
            case .unsupported:
                return "Unsupported domain."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}

/// Represents errors related to disallowed domains.
public enum DisallowedDomainError: Error, LocalizedError, CustomStringConvertible {

    /// Handle domain can't be used.
    case disallowed
    
    public var errorDescription: String? {
        switch self {
            case .disallowed:
                return "Disallowed domain."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}

/// Represents errors related to invalid Namespace Identifiers (NSIDs).
public enum InvalidNSIDError: Error, LocalizedError, CustomStringConvertible {

    /// Namespace Identifier (NSID) has at least one invalid character.
    case disallowedCharacter

    /// Namespace Identifier (NSID) is too long.
    ///
    /// - Parameter maxCharacters: The maximum number of characters the Namespace Identifier (NSID)
    /// can have.
    case tooLong(maxCharacters: Int)

    /// There are less than three segments in the Namespace Identifier (NSID).
    case notEnoughSegments

    /// At least one part of the Namespace Identifier (NSID) is empty.
    case nsidPartEmpty

    /// At least one Namespace Identifier (NSID) part is too long.
    ///
    /// - Parameter maxCharacters: The maximum number of characters the Namespace Identifier (NSID) part
    /// can have.
    case nsidPartTooLong(maxCharacters: Int)

    /// At least one Namespace Identifier (NSID) part starts with, or ends with, a hyphen.
    case nsidPartStartsOrEndsWithHyphen

    /// At least one Namespace Identifier (NSID) part starts with a digit.
    case nsidPartStartsWithDigit

    /// At least one Namespace Identifier (NSID) part contains an invalid character.
    case nsidNamePartContainsInvalidCharacter

    /// Namespace Identifier (NSID) couldn't be validated using a regular expression.
    case didntValidateViaRegex

    public var errorDescription: String? {
        switch self {
            case .disallowedCharacter:
                return "NSID has at least one invalid character."
            case .tooLong(let maxCharacters):
                return "NSID is too long. The maximum number of characters is \(maxCharacters)."
            case .notEnoughSegments:
                return "NSID should have at least three segments."
            case .nsidPartEmpty:
                return "One or more NSID parts are empty."
            case .nsidPartTooLong(let maxCharacters):
                return "One or more NSID parts are too long. The maximum number of characters is \(maxCharacters)."
            case .nsidPartStartsOrEndsWithHyphen:
                return "One or more NSID parts start or end with a hyphen (-)."
            case .nsidPartStartsWithDigit:
                return "One or more NSID parts start with a digit."
            case .nsidNamePartContainsInvalidCharacter:
                return "One or more NSID name parts contain invalid characters."
            case .didntValidateViaRegex:
                return "NSID couldn't be validated using a regular expression."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}

/// Represents errors related to invalid Record Keys.
public enum InvalidRecordKeyError: Error, LocalizedError, CustomStringConvertible {

    /// Record Key is not at the valid length.
    case invalidLength

    /// Record Key contains invalid syntax.
    case invalidSyntax

    /// Record Key contains one or two peroids.
    case onlyContainsPeriods

    public var errorDescription: String? {
        switch self {
            case .invalidLength:
                return "Record Key is not at the valid length. Record Keys must be between 1 and 512 characters long."
            case .invalidSyntax:
                return "Record Key contains invalid syntax."
            case .onlyContainsPeriods:
                return "Record Key contains one or two periods."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}

/// Represents errors related to invalid Timestamp Identifiers (TIDs).
public enum InvalidTIDError: Error, LocalizedError, CustomStringConvertible {

    /// Timestamp Identifier (TID) is not at the valid length.
    ///
    /// - Parameters:
    ///   - minimum: The minimum number of characters the Timestamp Identifier can have.
    ///   - maximum: The maximum number of characters the Timestamp Identifier can have.
    case invalidLength(minimum: Int, maximum: Int)

    /// Timestamp Identifier (TID) contains invalid syntax.
    case invalidSyntax

    public var errorDescription: String? {
        switch self {
            case .invalidLength(let minimum, let maximum):
                return "Invalid TID length. Must be between \(minimum) to \(maximum)."
            case .invalidSyntax:
                return "Invalid TID syntax."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}

/// Represents errors related to invalid AT URIs.
public enum InvalidATURIError: Error, LocalizedError, CustomStringConvertible {

    /// AT URI contains more than one hashtag.
    case tooManyHashtags

    /// There is at least one invalid character.
    case disallowedCharacters

    /// AT URI doesn't contain `at://` as its prefix.
    case noATPrefix

    /// AT URI's method and/or authority parts are empty.
    case noMethodOrAuthorityParts

    /// The handle or DID of the authority part of the AT URI are invalid.
    case invalidHandleOrDIDInAuthorityPart

    /// AT URI contains a slash after the authority segment while it lacks a path segment.
    case containsSlashAfterAuthoritySegmentWithoutPathSegment

    /// The Namespaced Identifier (NSID) in the path segment is invalid.
    case invalidNSIDInFirstPathSegment

    /// AT URI contains the slash character in the collection segment while lacking a Record Key.
    case containsSlashAfterCollectionWithNoRecordKey

    /// AT URI contains an invalid number of parts with a trailing slash.
    case invalidNumberOfPartsWithTrailingSlash

    /// AT URI's fragment part is empty, with a slash character at the start.
    case emptyFragmentPartWithSlashAtTheStart

    /// AT URI has too many characters.
    case tooLong

    /// AT URI has more than two path segments and/or has a trailing slash.
    case tooManyPathSegmentsAndOrHasTrailingSlash

    /// There is at least one invalid character in the fragment segment.
    case disallowedCharactersInFragmentSegment

    /// AT URI couldn't be validated using a regular expression.
    case didntValidateViaRegex

    public var errorDescription: String? {
        switch self {
            case .tooManyHashtags:
                return "Too many hashtags."
            case .disallowedCharacters:
                return "Invalid character in AT URI."
            case .noATPrefix:
                return "Doesn't contain `at://` as its prefix."
            case .noMethodOrAuthorityParts:
                return "Method and/or authority parts of the AT URI are empty."
            case .invalidHandleOrDIDInAuthorityPart:
                return "The handle or DID of the authority part of the AT URI are invalid."
            case .containsSlashAfterAuthoritySegmentWithoutPathSegment:
                return "AT URI contains a slash `/` after the authority segment, while it lacks a path segment."
            case .invalidNSIDInFirstPathSegment:
                return "The NSID in the first path segment of the AT URI is invalid."
            case .containsSlashAfterCollectionWithNoRecordKey:
                return "AT URI contains a slash `/` after a collection segment while lacking a Record Key."
            case .invalidNumberOfPartsWithTrailingSlash:
                return "AT URI has an invalid number of parts with a trailing slash."
            case .emptyFragmentPartWithSlashAtTheStart:
                return "AT URI's fragment part is empty, with a slash character at the start."
            case .tooLong:
                return "AT URI has too many characters."
            case .tooManyPathSegmentsAndOrHasTrailingSlash:
                return "AT URI has too many path segments and/or a trailing slash."
            case .disallowedCharactersInFragmentSegment:
                return "Invalid character in the fragment segment of the AT URI."
            case .didntValidateViaRegex:
                return "The string didn't validate via regular expression."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}
