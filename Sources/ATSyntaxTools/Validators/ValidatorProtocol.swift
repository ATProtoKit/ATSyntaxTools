//
//  ValidatorProtocol.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2025-05-06.
//

import Foundation

/// A protocol that defines the interface for normalizing and validating raw identifiers.
///
/// Conforming types must provide custom logic to:
/// - Normalize input, such as standardize the casing or ensuring consistent formatting.
/// - Validate the input for structural correctness, conformance to specifications, and other rules.
///
/// These functions are essential in the AT Protocol to enforce compliance with expected formats like
/// decentralized identifiers (DIDs) or AT URIs. They throw specific errors to explain why a given input
/// is invalid.
public protocol ValidatorProtocol {

    /// Normalizes a value into a standard format for reliable parsing and comparison.
    ///
    /// - Note: This method does not return a value. Implementations typically mutate internal state
    ///         or rely on computed properties to expose the normalized result.
    ///
    /// - Throws: An error if normalization fails due to structural issues or invalid content.
    func normalize() throws

    /// Validates the current value against format and specification rules.
    ///
    /// - Note: This method ensures that the value meets all structural and semantic rules required
    ///         by the AT Protocol, DID spec, or other context-specific schemas.
    ///
    /// - Throws: An error if validation fails, such as invalid segments, disallowed characters, or
    ///           insufficient structure.
    func validate() throws
}
