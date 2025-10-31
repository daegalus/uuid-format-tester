import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/parsing.dart';
import 'package:uuid_short_web/src/sample_feature/uuid_ncname.dart';

void main() {
  group('UUID-NCName Encoding Tests', () {
    // Test vectors from the specification Appendix A
    // https://datatracker.ietf.org/doc/html/draft-taylor-uuid-ncname-04#appendix-A

    test('Nil UUID encoding', () {
      const uuidString = '00000000-0000-0000-0000-000000000000';
      final uuid = UuidParsing.parseAsByteList(uuidString);

      // Expected values from spec
      expect(
          UuidNCName.encodeBase32(uuid), equals('aaaaaaaaaaaaaaaaaaaaaaaaaa'));
      expect(UuidNCName.encodeBase64(uuid), equals('AAAAAAAAAAAAAAAAAAAAAA'));
      expect(UuidNCName.encodeBase58(uuid), equals('A111111111111111______A'));
    });

    test('UUID v6 encoding (ca6be4c8-cbaf-11ea-b2ab-00045a86c8a1)', () {
      const uuidString = 'ca6be4c8-cbaf-11ea-b2ab-00045a86c8a1';
      final uuid = UuidParsing.parseAsByteList(uuidString);

      // Expected values from spec
      expect(
          UuidNCName.encodeBase32(uuid), equals('bzjv6jsglv4pkfkyaarninsfbl'));
      expect(UuidNCName.encodeBase64(uuid), equals('BymvkyMuvHqKrAARahsihL'));
      expect(UuidNCName.encodeBase58(uuid), equals('B6fTkmTD22KpWbDq1LuiszL'));
    });

    test('UUID v2 encoding (000003e8-cbb9-21ea-b201-00045a86c8a1)', () {
      const uuidString = '000003e8-cbb9-21ea-b201-00045a86c8a1';
      final uuid = UuidParsing.parseAsByteList(uuidString);

      // Expected values from spec
      expect(
          UuidNCName.encodeBase32(uuid), equals('caaaah2glxepkeaiaarninsfbl'));
      expect(UuidNCName.encodeBase64(uuid), equals('CAAAD6Mu5HqIBAARahsihL'));
      expect(UuidNCName.encodeBase58(uuid), equals('C11KtP6Y9P3rRkvh2N1e__L'));
    });

    test('UUID v3 encoding (3d813cbb-47fb-32ba-91df-831e1593ac29)', () {
      const uuidString = '3d813cbb-47fb-32ba-91df-831e1593ac29';
      final uuid = UuidParsing.parseAsByteList(uuidString);

      // Expected values from spec
      expect(
          UuidNCName.encodeBase32(uuid), equals('dhwatzo2h7mv2dx4ddykzhlbjj'));
      expect(UuidNCName.encodeBase64(uuid), equals('DPYE8u0f7K6Hfgx4Vk6wpJ'));
      expect(UuidNCName.encodeBase58(uuid), equals('D2ioV6oTr9yq6dMojd469nJ'));
    });

    test('UUID v4 encoding (01867b2c-a0dd-459c-98d7-89e545538d6c)', () {
      const uuidString = '01867b2c-a0dd-459c-98d7-89e545538d6c';
      final uuid = UuidParsing.parseAsByteList(uuidString);

      // Expected values from spec
      expect(
          UuidNCName.encodeBase32(uuid), equals('eagdhwlfa3vm4rv4j4vcvhdlmj'));
      expect(UuidNCName.encodeBase64(uuid), equals('EAYZ7LKDdWcjXieVFU41sJ'));
      expect(UuidNCName.encodeBase58(uuid), equals('E3UZ99RxxUJC1v4dWsYtb_J'));
    });

    test('UUID v5 encoding (21f7f8de-8051-5b89-8680-0195ef798b6a)', () {
      const uuidString = '21f7f8de-8051-5b89-8680-0195ef798b6a';
      final uuid = UuidParsing.parseAsByteList(uuidString);

      // Expected values from spec
      expect(
          UuidNCName.encodeBase32(uuid), equals('feh37rxuakg4jnaabsxxxtc3ki'));
      expect(UuidNCName.encodeBase64(uuid), equals('FIff43oBRuJaAAZXveYtqI'));
      expect(UuidNCName.encodeBase58(uuid), equals('Fx7wEJfz9eb1TYzsrT7Zs_I'));
    });

    test('Custom test UUID (068d0f22-7ce5-4fe2-9f81-3a09af4ed880)', () {
      const uuidString = '068d0f22-7ce5-4fe2-9f81-3a09af4ed880';
      final uuid = UuidParsing.parseAsByteList(uuidString);

      // Expected values from spec introduction
      expect(
          UuidNCName.encodeBase32(uuid), equals('ea2gq6it44x7c7aj2bgxu5weaj'));
      expect(UuidNCName.encodeBase64(uuid), equals('EBo0PInzl_i-BOgmvTtiAJ'));
      expect(UuidNCName.encodeBase58(uuid), equals('EBdYYqP7vH96E8SLjJaTH_J'));
    });
  });

  group('UUID-NCName Decoding Tests', () {
    test('Base32 round-trip', () {
      const uuidString = '068d0f22-7ce5-4fe2-9f81-3a09af4ed880';
      final uuid = UuidParsing.parseAsByteList(uuidString);

      final encoded = UuidNCName.encodeBase32(uuid);
      final decoded = UuidNCName.decode(encoded);

      expect(decoded, equals(uuid));
      expect(UuidNCName.toCanonicalUuid(decoded), equals(uuidString));
    });

    test('Base58 round-trip', () {
      const uuidString = '068d0f22-7ce5-4fe2-9f81-3a09af4ed880';
      final uuid = UuidParsing.parseAsByteList(uuidString);

      final encoded = UuidNCName.encodeBase58(uuid);
      final decoded = UuidNCName.decode(encoded);

      expect(decoded, equals(uuid));
      expect(UuidNCName.toCanonicalUuid(decoded), equals(uuidString));
    });

    test('Base64 round-trip', () {
      const uuidString = '068d0f22-7ce5-4fe2-9f81-3a09af4ed880';
      final uuid = UuidParsing.parseAsByteList(uuidString);

      final encoded = UuidNCName.encodeBase64(uuid);
      final decoded = UuidNCName.decode(encoded);

      expect(decoded, equals(uuid));
      expect(UuidNCName.toCanonicalUuid(decoded), equals(uuidString));
    });

    test('All test vectors round-trip Base32', () {
      final testVectors = [
        '00000000-0000-0000-0000-000000000000',
        'ca6be4c8-cbaf-11ea-b2ab-00045a86c8a1',
        '000003e8-cbb9-21ea-b201-00045a86c8a1',
        '3d813cbb-47fb-32ba-91df-831e1593ac29',
        '01867b2c-a0dd-459c-98d7-89e545538d6c',
        '21f7f8de-8051-5b89-8680-0195ef798b6a',
      ];

      for (final uuidString in testVectors) {
        final uuid = UuidParsing.parseAsByteList(uuidString);
        final encoded = UuidNCName.encodeBase32(uuid);
        final decoded = UuidNCName.decode(encoded);
        expect(UuidNCName.toCanonicalUuid(decoded), equals(uuidString),
            reason: 'Round-trip failed for $uuidString');
      }
    });
  });

  group('UUID-NCName Detection', () {
    test('Detect Base32 by length', () {
      const ncname = 'ea2gq6it44x7c7aj2bgxu5weaj';
      expect(ncname.length, equals(26));
      final decoded = UuidNCName.decode(ncname);
      expect(decoded.length, equals(16));
    });

    test('Detect Base58 by length', () {
      const ncname = 'EBdYYqP7vH96E8SLjJaTH_J';
      expect(ncname.length, equals(23));
      final decoded = UuidNCName.decode(ncname);
      expect(decoded.length, equals(16));
    });

    test('Detect Base64 by length', () {
      const ncname = 'EBo0PInzl_i-BOgmvTtiAJ';
      expect(ncname.length, equals(22));
      final decoded = UuidNCName.decode(ncname);
      expect(decoded.length, equals(16));
    });
  });

  group('Case Sensitivity Tests', () {
    test('Base32 is case-insensitive', () {
      const uuidString = '068d0f22-7ce5-4fe2-9f81-3a09af4ed880';
      final uuid = UuidParsing.parseAsByteList(uuidString);

      final lowercase = UuidNCName.encodeBase32(uuid, lowercase: true);
      final uppercase = UuidNCName.encodeBase32(uuid, lowercase: false);

      expect(lowercase.toUpperCase(), equals(uppercase));
      expect(UuidNCName.decode(lowercase), equals(uuid));
      expect(UuidNCName.decode(uppercase), equals(uuid));
    });

    test('Base58/Base64 bookends are case-insensitive', () {
      const uuidString = '068d0f22-7ce5-4fe2-9f81-3a09af4ed880';
      final uuid = UuidParsing.parseAsByteList(uuidString);

      final b58Upper = UuidNCName.encodeBase58(uuid, uppercaseBookends: true);
      final b58Lower = UuidNCName.encodeBase58(uuid, uppercaseBookends: false);

      expect(b58Upper[0].toUpperCase(), equals(b58Lower[0].toUpperCase()));
      expect(b58Upper[b58Upper.length - 1].toUpperCase(),
          equals(b58Lower[b58Lower.length - 1].toUpperCase()));
    });
  });
}
