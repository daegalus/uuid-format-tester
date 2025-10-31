/// Common alphabets used for base encoding of UUIDs.
library;

/// Base48 alphabet excluding similar-looking characters.
/// Excludes: 0, O, 1, I, l (zero, capital O, one, capital I, lowercase L)
const String base48Alphabet =
    'ABCDEFGHJKLMNOPQRSTVWXYZabcdefghijkmnopqrstvwxyz';

/// Base52 alphabet - full upper and lowercase letters.
const String base52Alphabet =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

/// Reference UUID for testing and validation.
/// From: https://github.com/uuid6/new-uuid-encoding-techniques-ietf-draft/blob/master/TRADEOFFS.md#summary-of-concerns-and-tradeoffs
const String referenceUuid = 'f81d4fae-7dec-11d0-a765-00a0c91e6bf6';
