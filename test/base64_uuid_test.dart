import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_short_web/src/encoders/base64_uuid.dart';

void main() {
  group('Base64UUID Encoding', () {
    test('encodes nil UUID', () {
      expect(
        encodeBase64UUID('00000000-0000-0000-0000-000000000000'),
        equals(r'F$$$$$$$$$$$$$$$$$$$$$'),
      );
    });

    test('encodes max UUID', () {
      expect(
        encodeBase64UUID('ffffffff-ffff-ffff-ffff-ffffffffffff'),
        equals('Izzzzzzzzzzzzzzzzzzzzz'),
      );
    });

    test('round-trip encoding and decoding', () {
      // Base64UUID is lossless - it preserves all 128 bits by prepending
      // a 4-bit prefix to create 132 bits total
      const testUuids = [
        '00000000-0000-0000-0000-000000000000',
        'ffffffff-ffff-ffff-ffff-ffffffffffff', // Max UUID with all bits set
        '123e4567-e89b-12d3-a456-426614174000',
        'c3d4e5f6-a7b8-4c9d-8e7f-6a5b4c3d2e1f',
        '11111111-1111-1111-1111-111111111117', // Random last nibble
        '0189f7a8-1234-7abc-9def-0123456789af', // UUIDv7 example with random bits
      ];

      for (final uuid in testUuids) {
        final encoded = encodeBase64UUID(uuid);
        expect(encoded.length, equals(22),
            reason: 'Encoded length should be 22');

        final decoded = decodeBase64UUID(encoded);
        expect(decoded, equals(uuid), reason: 'Round-trip failed for $uuid');
      }
    });

    test('encoded strings start with F, G, H, or I', () {
      const testUuids = [
        '00000000-0000-0000-0000-000000000000',
        'ffffffff-ffff-ffff-ffff-ffffffffffff',
        '123e4567-e89b-12d3-a456-426614174000',
        '99999999-9999-9999-9999-999999999999',
        'c3d4e5f6-a7b8-4c9d-8e7f-6a5b4c3d2e1f',
      ];

      for (final uuid in testUuids) {
        final encoded = encodeBase64UUID(uuid);
        final firstChar = encoded[0];
        expect(
          ['F', 'G', 'H', 'I'].contains(firstChar),
          isTrue,
          reason:
              'Encoded UUID $uuid should start with F, G, H, or I, but got $firstChar',
        );
      }
    });

    test('handles quoted strings in decoder', () {
      const encoded = r'"F$$$$$$$$$$$$$$$$$$$$$"';
      final decoded = decodeBase64UUID(encoded);
      expect(decoded, equals('00000000-0000-0000-0000-000000000000'));
    });

    test('throws on invalid Base64UUID length', () {
      expect(
        () => decodeBase64UUID(r'F$$$'),
        throwsArgumentError,
      );
    });

    test('throws on invalid Base64UUID character', () {
      expect(
        () => decodeBase64UUID('F@@@@@@@@@@@@@@@@@@@@@'),
        throwsArgumentError,
      );
    });

    test('preserves sort order', () {
      // UUIDs in ascending order (with last nibble = 0 for lossless round-trip)
      const uuids = [
        '00000000-0000-0000-0000-000000000000',
        '11111110-1111-1111-1111-111111111110',
        '22222220-2222-2222-2222-222222222220',
        'aaaaaaa0-aaaa-aaaa-aaaa-aaaaaaaaaaa0',
        'fffffff0-ffff-ffff-ffff-fffffffffff0',
      ];

      final encoded = uuids.map(encodeBase64UUID).toList();
      final sortedEncoded = List<String>.from(encoded)..sort();

      expect(encoded, equals(sortedEncoded),
          reason: 'Encoded strings should maintain sort order');
    });
  });
}
