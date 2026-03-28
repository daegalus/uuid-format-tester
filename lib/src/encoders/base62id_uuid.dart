/// Implementation of the Base62id UUID encoding specification.
///
/// Spec: https://github.com/sergeyprokhorenko/Base62id
///
/// Base62id prepends a fixed 2-bit prefix (`10`) to the 128-bit UUID value,
/// producing a sortable 130-bit integer that encodes to exactly 22 Base62
/// characters. The first character is always an uppercase letter.
library;

import '../constants/alphabets.dart';

final BigInt _base62 = BigInt.from(62);
final BigInt _base62IdPrefix = BigInt.from(2) << 128;
final BigInt _uuidMask = (BigInt.one << 128) - BigInt.one;
final RegExp _uuidHexPattern = RegExp(r'^[0-9a-fA-F]{32}$');

const int _base62IdLength = 22;

/// Encodes a UUID string into Base62id.
///
/// The input may be provided with or without dashes.
String encodeBase62Id(String uuid) {
  final hex = uuid.replaceAll('-', '');
  if (!_uuidHexPattern.hasMatch(hex)) {
    throw ArgumentError(
      'UUID must contain exactly 32 hexadecimal characters after removing dashes',
    );
  }

  var value = _base62IdPrefix | BigInt.parse(hex, radix: 16);
  final chars = List<String>.filled(_base62IdLength, base62SortAlphabet[0]);

  for (var i = _base62IdLength - 1; i >= 0; i--) {
    final digit = (value % _base62).toInt();
    chars[i] = base62SortAlphabet[digit];
    value ~/= _base62;
  }

  if (value != BigInt.zero) {
    throw StateError('Base62id encoding overflowed 22 characters');
  }

  return chars.join();
}

/// Decodes a Base62id string back to a canonical UUID string.
///
/// The decoder accepts optional surrounding double quotes.
String decodeBase62Id(String encoded) {
  var value = BigInt.zero;
  var str = encoded.trim();

  if (str.startsWith('"') && str.endsWith('"') && str.length > 2) {
    str = str.substring(1, str.length - 1);
  }

  if (str.length != _base62IdLength) {
    throw ArgumentError(
      'Base62id string must be exactly $_base62IdLength characters, got ${str.length}',
    );
  }

  for (final char in str.split('')) {
    final index = base62SortAlphabet.indexOf(char);
    if (index == -1) {
      throw ArgumentError('Invalid Base62id character: $char');
    }

    value = (value * _base62) + BigInt.from(index);
  }

  final hex = (value & _uuidMask).toRadixString(16).padLeft(32, '0');
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
}
