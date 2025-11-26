/// Common alphabets used for base encoding of UUIDs.
library;

/// Base48 alphabet excluding similar-looking characters.
/// Excludes: 0, O, 1, I, l (zero, capital O, one, capital I, lowercase L)
const String base48Alphabet =
    'ABCDEFGHJKLMNOPQRSTVWXYZabcdefghijkmnopqrstvwxyz';

/// Base52 alphabet - full upper and lowercase letters.
const String base52Alphabet =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

/// Base62 alphabet (sort variant) - digits first, then uppercase, then lowercase.
/// This is the standard Base62 ordering used by many implementations.
const String base62SortAlphabet =
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

/// Base62 alphabet (IEEE variant) - uppercase first, then lowercase, then digits.
/// This follows the IEEE alphabet standard.
const String base62IeeeAlphabet =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

/// Reference UUID for testing and validation.
/// From: https://github.com/uuid6/new-uuid-encoding-techniques-ietf-draft/blob/master/TRADEOFFS.md#summary-of-concerns-and-tradeoffs
const String referenceUuid = 'f81d4fae-7dec-11d0-a765-00a0c91e6bf6';
