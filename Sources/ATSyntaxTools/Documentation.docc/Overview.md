# ``ATSyntaxTools``

Validate various AT Protocol-specific identifiers.

@Metadata {
    @PageImage(
               purpose: icon, 
               source: "atsyntaxtools_icon", 
               alt: "A technology icon representing the ATSyntaxTools framework.")
    @PageColor(blue)
}

## Overview

ATSyntaxTools is a Swift package used for validating the various identifiers within the AT Protocol. This is useful for type-checking whether something is valid before sending it off to a server.

## Quick Examples

### Handles

```swift
import ATSyntaxTools

do {
    let isHandleValid = HandleValidator.isHandleValid("alice.test")
    print(isHandleValid) // returns `true`.

    try HandleValidator.validate("alice.test") // Doesn't throw; handle is valid.

    let isHandleValid2 = HandleValidator.isHandleValid("al!ce.test")
    print(isHandleValid2) // returns `false`.

    try HandleValidator.validate("al!ce.test") // Throws InvalidHandleError.
} catch {
    print(error)
}
```

### Decentralized Identifier (DID)

```swift
import ATSyntaxTools

do {
    try DIDValidator.validate("did:method:val") // Doesn't throw; DID is valid.
    try DIDValidator.validate(":did:method:val") // Throws InvalidDIDError.
} catch {
    print(error)
}
```

### Namespaced Identifier (NSID)

```swift
import ATSyntaxTools

do {
    try NSIDValidator.validate("com.example.foo") // Doesn't throw; NSID is valid.
    try NSIDValidator.validate("com.example.someRecord") // Doesn't throw; NSID is valid.
    try NSIDValidator.validate("example.com/foo") // Throws InvalidNSIDError.
    try NSIDValidator.validate("foo") // Throws InvalidNSIDError.
} catch {
    print(error)
}
```

### AT URIs

```swift
import ATSyntaxTools

do {
    try ATURIValidator.validate("at://bob.com/com.example.post/1234") // Doesn't throw; AT URI is valid.
    try ATURIValidator.validate("at:://bob.com/com.examp!e.2/1234") // Throws InvalidATURIError
} catch {
    print(error)
}
```

This is a lightweight, simple package that can be used for both the ATProtoKit family of Swift packages, as well as any AT Protocol packages unrelated to ATProtoKit. Not only is validation within the scope of best practices with respect to Swift, but it'll help to reduce less potenital bugs and errors.

ATSyntaxTools is fully open source under the [Apache 2.0 license](https://github.com/ATProtoKit/ATSyntaxTools/blob/main/LICENSE.md). You can take a look at it and make contributions to it [on GitHub](https://github.com/ATProtoKit/ATSyntaxTools).

## Topics

### Articles

- <doc:ValidatingIdentifiersAndSchemes>

### AT URIs

- ``ATURIValidator``

### Decentralized Identifiers (DIDs)

- ``DIDValidator``

### Handles

- ``HandleValidator``

### Namespaced Identifiers (NSIDs)

- ``NSIDValidator``

### Record Keys

- ``RecordKeyValidator``

### Timestamp Identifiers (TIDs)

- ``TIDValidator``

### Error Handling

- ``InvalidDIDError``
- ``InvalidHandleError``
- ``ReservedHandleError``
- ``UnsupportedDomainError``
- ``DisallowedDomainError``
- ``InvalidNSIDError``
- ``InvalidRecordKeyError``
- ``InvalidTIDError``
- ``InvalidATURIError``
- ``PunycodeError``

### Canonicalizable

- ``Canonicalizable``
- ``ValidatorProtocol``
- ``NormalizerProtocol``

### Utilities

- ``RegexMatch``
- ``Punycode``
