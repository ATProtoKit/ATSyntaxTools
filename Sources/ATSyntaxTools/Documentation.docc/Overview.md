# ``ATSyntaxTools``

Validate various AT Protocol-specific identifiers.

## Overview

ATSyntaxTools is a Swift package used for validating the various identifiers within the AT Protocol. This is useful for type-checking whether something is valid before sending it off to a server. This is a lightweight, simple package that can be used for both the ATProtoKit family of Swift packages, as well as any AT Protocol packages unrelated to ATProtoKit. Not only is validation within the scope of best practices with respect to Swift, but it'll help to reduce less potenital bugs and errors.

ATSyntaxTools is fully open source under the [MIT license](https://github.com/ATProtoKit/ATSyntaxTools/blob/main/LICENSE.md). You can take a look at it and make contributions to it [on GitHub](https://github.com/ATProtoKit/ATSyntaxTools).

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

### Canonicalizable

- ``Canonicalizable``
- ``ValidatorProtocol``
- ``NormalizerProtocol``

### Utilities

- ``RegexMatch``
