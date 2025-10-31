# UUID Encoders Library

This library provides various encoding schemes for UUIDs, suitable for use in URLs, filenames, XML, and other contexts where standard UUID format is not ideal.

## Encoders

### Base64UUID

A lossless encoding that represents a UUID as a 22-character Base64 string.

**Features:**
- Uses 132 bits total (4-bit prefix + 128-bit UUID)
- URL-safe Base64 alphabet (A-Z, a-z, 0-9, -, _)
- Fully reversible (lossless)
- Shorter than standard UUID format (22 vs 36 characters)

**Usage:**
```dart
import 'package:uuid_short_web/src/encoders/encoders.dart';

// Encode
final uuid = '0f2a4b6d-8c9e-4f1a-b3d5-e6f7a8b9c0d1';
final encoded = encodeBase64UUID(uuid);
print(encoded); // "BwqS234-Txqz1eb-ouJwNBQ"

// Decode
final decoded = decodeBase64UUID(encoded);
print(decoded); // "0f2a4b6d-8c9e-4f1a-b3d5-e6f7a8b9c0d1"
```

### UUID-NCName

Implements the IETF UUID-NCName specification for encoding UUIDs as XML NCNames (names that can be used as XML element/attribute names).

**Features:**
- Three encoding schemes: Base32, Base58, and Base64
- Each encoding includes a single-letter prefix indicating the UUID version
- Base32 and Base64 support uppercase/lowercase options
- Base58 uses bookend characters to ensure valid NCName format
- Fully reversible with format detection

**Encoding Formats:**

| Format  | Length | Alphabet | Example |
|---------|--------|----------|---------|
| Base32  | 27     | A-Z, 2-7 | `bzjv6jsglv4pkfkyaarninsfbl` |
| Base58  | 24     | A-Z, a-z, 0-9, _, - | `B6fTkmTD22KpWbDq1LuiszL` |
| Base64  | 23     | A-Z, a-z, 0-9, _, - | `BymvkyMuvHqKrAARahsihL` |

**Usage:**
```dart
import 'package:uuid_short_web/src/encoders/encoders.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();
final uuidBytes = uuid.v4buffer(Uint8List(16));

// Base32 encoding (uppercase by default)
final b32 = UuidNCName.encodeBase32(uuidBytes);
print(b32); // e.g., "DABC123XYZ..."

// Base32 lowercase
final b32Lower = UuidNCName.encodeBase32(uuidBytes, lowercase: true);
print(b32Lower); // e.g., "dabc123xyz..."

// Base58 encoding (with uppercase bookends by default)
final b58 = UuidNCName.encodeBase58(uuidBytes);
print(b58); // e.g., "D1a2B3c4..."

// Base64 encoding
final b64 = UuidNCName.encodeBase64(uuidBytes);
print(b64); // e.g., "DABC123..."

// Decode (automatically detects format)
final decoded = UuidNCName.decode(b32);
print(decoded); // Original bytes

// Convert back to canonical UUID string
final canonical = UuidNCName.toCanonicalUuid(decoded);
print(canonical); // e.g., "123e4567-e89b-12d3-a456-426614174000"
```

## Version Prefixes

UUID-NCName encodings include a single-letter prefix indicating the UUID version:

- `a` - UUID v0 (NIL UUID: all zeros)
- `b` - UUID v1 (timestamp-based)
- `c` - UUID v2 (DCE security)
- `d` - UUID v3 (MD5 hash)
- `e` - UUID v4 (random)
- `f` - UUID v5 (SHA-1 hash)
- `g` - UUID v6 (reordered timestamp)
- `h` - UUID v7 (Unix timestamp)
- `i` - UUID v8 (custom)

## Dependencies

- `dart:convert` - Base64 encoding
- `dart:typed_data` - Byte manipulation
- `package:base32` - Base32 encoding
- `package:b` - Base conversion utilities

## Use Cases

- **URL shortening**: Use shorter encoded UUIDs in URLs
- **Filenames**: Create valid, compact filenames from UUIDs
- **XML/HTML**: Use as element IDs or attribute values (NCName compliant)
- **Database keys**: Shorter primary keys while maintaining uniqueness
- **QR codes**: Reduce QR code complexity with shorter representations

## Extracting as a Package

This library is designed to be easily extracted into a standalone Dart package:

1. Copy the `encoders/` directory
2. Copy `constants/alphabets.dart`
3. Update imports to use the package name
4. Add dependencies to `pubspec.yaml`:
   - `base32: ^2.1.3`
   - `b: ^0.2.0`
5. Add comprehensive tests
6. Publish to pub.dev

## License

See project LICENSE file.
