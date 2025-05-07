//
//  ValidatorProtocol.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2025-05-06.
//

import Foundation

/// A protocol that defines the interface for validating raw identifiers.
///
/// The required functions are essential in the AT Protocol to enforce compliance with expected formats like
/// decentralized identifiers (DIDs) or AT URIs. They throw specific errors to explain why a given input
/// is invalid.
public protocol ValidatorProtocol {

    /// Validates the current value against format and specification rules.
    ///
    /// - Parameter identifier: The specific identifier to validate.
    ///
    /// - Throws: An error if validation fails, such as invalid segments, disallowed characters, or
    ///           insufficient structure.
    func validate(_ identifier: String) throws
}

/// A protocol for types that normalize raw identifier input into a standardized, canonical form.
public protocol NormalizerProtocol {

    /// The output type produced after normalization.
    associatedtype Identifier = String

    /// Normalizes a value into a more standard format.
    ///
    /// - Parameter identifier: The specific identifier to normalize.
    /// - Returns: The normalized identifier.
    ///
    /// - Throws: An error if normalization fails due to structural issues or invalid content.
    func normalize(_ identifier: String) throws -> Identifier
}

/// A protocol that defines the interface for normalizing and validating raw identifiers.
///
/// Conforming types must provide custom logic to:
/// - Normalize input, such as standardize the casing or ensuring consistent formatting.
/// - Validate the input for structural correctness, conformance to specifications, and other rules.
///
/// These functions are essential in the AT Protocol to enforce compliance with expected formats like
/// decentralized identifiers (DIDs) or AT URIs. They throw specific errors to explain why a given input
/// is invalid.
typealias Canonicalizable = ValidatorProtocol & NormalizerProtocol
