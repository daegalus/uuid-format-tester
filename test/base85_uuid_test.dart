import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/parsing.dart';
import 'package:uuid_short_web/src/encoders/base85_uuid.dart';

void main() {
  group('Base85 UUID Encoding Tests', () {
    test('encodeAscii85 produces valid output for standard UUID', () {
      // Test UUID: 123e4567-e89b-12d3-a456-426614174000
      const uuidString = '123e4567-e89b-12d3-a456-426614174000';
      final uuidBytes = UuidParsing.parseAsByteList(uuidString);

      final encoded = encodeAscii85(uuidBytes);

      // Ascii85 encodes 16 bytes into 20 characters (or less with 'z' compression)
      expect(encoded.length, lessThanOrEqualTo(20));
      // Should only contain valid Ascii85 characters (! to u, and z)
      expect(encoded, matches(r'^[!-uz]+$'));
    });

    test('encodeAscii85 handles UUID with zero bytes', () {
      // UUID with some zero bytes: 00000000-0000-0000-0000-000000000000
      const uuidString = '00000000-0000-0000-0000-000000000000';
      final uuidBytes = UuidParsing.parseAsByteList(uuidString);

      final encoded = encodeAscii85(uuidBytes);

      // All zeros should compress to 'zzzz' (4 groups of 4 zero bytes)
      expect(encoded, equals('zzzz'));
    });

    test('encodeZ85 produces valid output for standard UUID', () {
      // Test UUID: 123e4567-e89b-12d3-a456-426614174000
      const uuidString = '123e4567-e89b-12d3-a456-426614174000';
      final uuidBytes = UuidParsing.parseAsByteList(uuidString);

      final encoded = encodeZ85(uuidBytes);

      // Z85 always encodes 16 bytes into exactly 20 characters
      expect(encoded.length, equals(20));
      // Should only contain valid Z85 characters
      expect(
        encoded,
        matches(r'^[0-9a-zA-Z.\-:+=^!/*?&<>()\[\]{}@%$#]+$'),
      );
    });

    test('encodeZ85 handles UUID with zero bytes', () {
      // UUID with some zero bytes
      const uuidString = '00000000-0000-0000-0000-000000000000';
      final uuidBytes = UuidParsing.parseAsByteList(uuidString);

      final encoded = encodeZ85(uuidBytes);

      // Z85 doesn't use special compression, always 20 characters
      expect(encoded.length, equals(20));
      expect(encoded, equals('00000000000000000000'));
    });

    test('encodeAscii85 throws on invalid byte length', () {
      final invalidBytes = Uint8List.fromList([0x12, 0x34]);

      expect(
        () => encodeAscii85(invalidBytes),
        throwsArgumentError,
      );
    });

    test('encodeZ85 throws on invalid byte length', () {
      final invalidBytes = Uint8List.fromList([0x12, 0x34]);

      expect(
        () => encodeZ85(invalidBytes),
        throwsArgumentError,
      );
    });

    test('different UUIDs produce different encodings', () {
      const uuid1 = '123e4567-e89b-12d3-a456-426614174000';
      const uuid2 = 'f47ac10b-58cc-4372-a567-0e02b2c3d479';

      final bytes1 = UuidParsing.parseAsByteList(uuid1);
      final bytes2 = UuidParsing.parseAsByteList(uuid2);

      final ascii85_1 = encodeAscii85(bytes1);
      final ascii85_2 = encodeAscii85(bytes2);
      final z85_1 = encodeZ85(bytes1);
      final z85_2 = encodeZ85(bytes2);

      expect(ascii85_1, isNot(equals(ascii85_2)));
      expect(z85_1, isNot(equals(z85_2)));
    });

    test('Base85 encodings are URL-safe for Z85', () {
      const uuidString = '123e4567-e89b-12d3-a456-426614174000';
      final uuidBytes = UuidParsing.parseAsByteList(uuidString);

      final z85 = encodeZ85(uuidBytes);

      // Z85 alphabet avoids quotes and backslash
      expect(z85, isNot(contains('"')));
      expect(z85, isNot(contains("'")));
      expect(z85, isNot(contains('\\')));
    });

    test('encodeCustomBase85 produces valid output for standard UUID', () {
      // Test UUID: 123e4567-e89b-12d3-a456-426614174000
      const uuidString = '123e4567-e89b-12d3-a456-426614174000';
      final uuidBytes = UuidParsing.parseAsByteList(uuidString);

      final encoded = encodeCustomBase85(uuidBytes);

      // Custom Base85 always encodes 16 bytes into exactly 20 characters
      expect(encoded.length, equals(20));
      // Should only contain valid Ascii85 alphabet characters (! to u)
      expect(encoded, matches(r'^[!-u]+$'));
    });

    test('encodeCustomBase85 handles UUID with zero bytes WITHOUT compression',
        () {
      // UUID with all zero bytes
      const uuidString = '00000000-0000-0000-0000-000000000000';
      final uuidBytes = UuidParsing.parseAsByteList(uuidString);

      final encoded = encodeCustomBase85(uuidBytes);

      // Custom variant does NOT use 'z' compression - always 20 characters
      expect(encoded.length, equals(20));
      expect(encoded, isNot(contains('z')));
      // All zeros should encode to '!!!!!' repeated (! is the zero character in base85)
      expect(encoded, equals('!!!!!!!!!!!!!!!!!!!!'));
    });

    test('encodeCustomBase85 differs from Ascii85 on zero bytes', () {
      // UUID with all zero bytes
      const uuidString = '00000000-0000-0000-0000-000000000000';
      final uuidBytes = UuidParsing.parseAsByteList(uuidString);

      final ascii85 = encodeAscii85(uuidBytes);
      final custom = encodeCustomBase85(uuidBytes);

      // Ascii85 uses 'z' compression, custom does not
      expect(ascii85, equals('zzzz'));
      expect(custom, equals('!!!!!!!!!!!!!!!!!!!!'));
      expect(ascii85, isNot(equals(custom)));
    });

    test('encodeCustomBase85 throws on invalid byte length', () {
      final invalidBytes = Uint8List.fromList([0x12, 0x34]);

      expect(
        () => encodeCustomBase85(invalidBytes),
        throwsArgumentError,
      );
    });
  });
}
