import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_short_web/src/encoders/base62id_uuid.dart';
import 'package:uuid_short_web/src/services/uuid_encoding_service.dart';

void main() {
  group('Base62id UUID Encoding', () {
    test('encodes the specification examples', () {
      expect(
        encodeBase62Id('00000000-0000-0000-0000-000000000000'),
        equals('Fa84QWiAxLXUJaHZmEVPEG'),
      );
      expect(
        encodeBase62Id('ffffffff-ffff-ffff-ffff-ffffffffffff'),
        equals('NNC6dn4GR1JETNQMfLl6qN'),
      );
      expect(
        encodeBase62Id('019b1515-3df8-7032-bfc6-06b5e46ff8f4'),
        equals('Fd9w4CutiyWHZha547fAai'),
      );
      expect(
        encodeBase62Id('123e4567-e89b-12d3-a456-426614174000'),
        equals('G8YOG5efuH94ezE3H5aIvQ'),
      );
    });

    test('round-trips encoded UUIDs', () {
      const testUuids = [
        '00000000-0000-0000-0000-000000000000',
        'ffffffff-ffff-ffff-ffff-ffffffffffff',
        '019b1515-3df8-7032-bfc6-06b5e46ff8f4',
        '123e4567-e89b-12d3-a456-426614174000',
        'c3d4e5f6-a7b8-4c9d-8e7f-6a5b4c3d2e1f',
      ];

      for (final uuid in testUuids) {
        final encoded = encodeBase62Id(uuid);
        expect(encoded.length, equals(22),
            reason: 'Encoded length should be 22');
        expect(decodeBase62Id(encoded), equals(uuid),
            reason: 'Round-trip failed for $uuid');
      }
    });

    test('encoded values always start with an uppercase letter', () {
      const testUuids = [
        '00000000-0000-0000-0000-000000000000',
        'ffffffff-ffff-ffff-ffff-ffffffffffff',
        '123e4567-e89b-12d3-a456-426614174000',
        '99999999-9999-9999-9999-999999999999',
        'c3d4e5f6-a7b8-4c9d-8e7f-6a5b4c3d2e1f',
      ];

      for (final uuid in testUuids) {
        final firstChar = encodeBase62Id(uuid)[0];
        expect(RegExp(r'^[A-Z]$').hasMatch(firstChar), isTrue,
            reason: 'Encoded UUID $uuid should start with uppercase letter');
      }
    });

    test('preserves lexicographic sort order', () {
      const uuids = [
        '00000000-0000-0000-0000-000000000000',
        '11111111-1111-1111-1111-111111111111',
        '22222222-2222-2222-2222-222222222222',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'ffffffff-ffff-ffff-ffff-ffffffffffff',
      ];

      final encoded = uuids.map(encodeBase62Id).toList();
      final sortedEncoded = List<String>.from(encoded)..sort();

      expect(encoded, equals(sortedEncoded),
          reason: 'Encoded strings should maintain sort order');
    });

    test('decoder accepts optional surrounding quotes', () {
      expect(
        decodeBase62Id('"G8YOG5efuH94ezE3H5aIvQ"'),
        equals('123e4567-e89b-12d3-a456-426614174000'),
      );
    });

    test('decoder rejects invalid lengths', () {
      expect(
        () => decodeBase62Id('G8YOG5efuH94ezE3H5aI'),
        throwsArgumentError,
      );
    });

    test('decoder rejects invalid characters', () {
      expect(
        () => decodeBase62Id('G8YOG5efuH94ezE3H5aIv!'),
        throwsArgumentError,
      );
    });

    test('service exposes Base62id as a Base62 variant', () {
      final result = UuidEncodingService().encodeUuid(
        '123e4567-e89b-12d3-a456-426614174000',
      );

      expect(result.base62.base62id, equals('G8YOG5efuH94ezE3H5aIvQ'));
    });
  });
}
