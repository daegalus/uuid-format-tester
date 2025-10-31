/// Controller for managing UUID list state and operations.
library;

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/uuid_encoding_result.dart';
import '../services/uuid_encoding_service.dart';

/// Controller that manages the list of UUID encodings.
class UuidListController extends ChangeNotifier {
  UuidListController(this._encodingService);

  final UuidEncodingService _encodingService;
  final List<UuidEncodingResult> _items = [];
  final Uuid _uuidGenerator = const Uuid();

  bool _lowercaseBase32 = false;
  String _uuidVersion = 'v7';

  /// The current list of encoded UUIDs.
  List<UuidEncodingResult> get items => List.unmodifiable(_items);

  /// Whether to use lowercase for Base32 encodings.
  bool get lowercaseBase32 => _lowercaseBase32;

  /// The currently selected UUID version for generation.
  String get uuidVersion => _uuidVersion;

  /// Adds a new UUID with the currently selected version.
  void addUuid() {
    final uuid = _generateUuid();
    final result = _encodingService.encodeUuid(
      uuid,
      lowercaseBase32: _lowercaseBase32,
    );
    _items.add(result);
    notifyListeners();
  }

  /// Adds multiple UUIDs at once.
  void addMultipleUuids(int count) {
    for (var i = 0; i < count; i++) {
      final uuid = _generateUuid();
      final result = _encodingService.encodeUuid(
        uuid,
        lowercaseBase32: _lowercaseBase32,
      );
      _items.add(result);
    }
    notifyListeners();
  }

  /// Adds a specific UUID string to the list.
  void addSpecificUuid(String uuidString) {
    final result = _encodingService.encodeUuid(
      uuidString,
      lowercaseBase32: _lowercaseBase32,
    );
    _items.add(result);
    notifyListeners();
  }

  /// Clears all UUIDs from the list.
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Sets whether to use lowercase for Base32 encodings.
  void setLowercaseBase32(bool value) {
    _lowercaseBase32 = value;
    notifyListeners();
  }

  /// Sets the UUID version to generate.
  void setUuidVersion(String version) {
    _uuidVersion = version;
    notifyListeners();
  }

  /// Generates a UUID based on the selected version.
  String _generateUuid() {
    return switch (_uuidVersion) {
      'v1' => _uuidGenerator.v1(),
      'v4' => _uuidGenerator.v4(),
      'v5' => _uuidGenerator.v5(Namespace.url.value, 'https://example.com'),
      'v6' => _uuidGenerator.v6(),
      'v7' => _uuidGenerator.v7(),
      'v8' => _uuidGenerator.v8(),
      _ => _uuidGenerator.v7(), // Default to v7
    };
  }
}
