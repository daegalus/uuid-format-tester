/// Control panel widget for UUID operations.
library;

import 'package:flutter/material.dart';

import '../controllers/uuid_list_controller.dart';
import '../localization/app_localizations.dart';

/// Panel with controls for generating and managing UUIDs.
class UuidControlsPanel extends StatefulWidget {
  const UuidControlsPanel({
    required this.controller,
    required this.scrollController,
    super.key,
  });

  final UuidListController controller;
  final ScrollController scrollController;

  @override
  State<UuidControlsPanel> createState() => _UuidControlsPanelState();
}

class _UuidControlsPanelState extends State<UuidControlsPanel> {
  final TextEditingController _customUuidController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _customUuidController.dispose();
    super.dispose();
  }

  void _addCustomUuid() {
    final uuid = _customUuidController.text.trim();

    // Basic UUID validation (8-4-4-4-12 format)
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );

    if (uuid.isEmpty) {
      setState(() {
        _errorText = 'Please enter a UUID';
      });
      return;
    }

    if (!uuidRegex.hasMatch(uuid)) {
      setState(() {
        _errorText =
            'Invalid UUID format (expected: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)';
      });
      return;
    }

    // Add the UUID
    widget.controller.addSpecificUuid(uuid.toLowerCase());
    _customUuidController.clear();
    setState(() {
      _errorText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Custom UUID Input
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: TextField(
              controller: _customUuidController,
              decoration: InputDecoration(
                labelText: 'Custom UUID',
                hintText:
                    'Enter UUID (e.g., 123e4567-e89b-12d3-a456-426614174000)',
                errorText: _errorText,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: _addCustomUuid,
                  tooltip: 'Add Custom UUID',
                ),
              ),
              onSubmitted: (_) => _addCustomUuid(),
            ),
          ),
          const SizedBox(height: 16),
          // UUID Version and Settings Row
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // UUID Version Selector
              DropdownMenu<String>(
                label: Text(localizations.uuidVersion),
                initialSelection: widget.controller.uuidVersion,
                onSelected: (String? value) {
                  if (value != null) {
                    widget.controller.setUuidVersion(value);
                  }
                },
                dropdownMenuEntries: [
                  DropdownMenuEntry(
                      value: 'v1', label: localizations.v1Timestamp),
                  DropdownMenuEntry(value: 'v4', label: localizations.v4Random),
                  DropdownMenuEntry(value: 'v5', label: localizations.v5Sha1),
                  DropdownMenuEntry(
                      value: 'v6', label: localizations.v6TimestampSorted),
                  DropdownMenuEntry(
                      value: 'v7', label: localizations.v7UnixTime),
                  DropdownMenuEntry(value: 'v8', label: localizations.v8Custom),
                ],
              ),
              // Lowercase Base32 Toggle
              ListenableBuilder(
                listenable: widget.controller,
                builder: (context, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(localizations.lowercaseBase32),
                      const SizedBox(width: 8),
                      Switch(
                        value: widget.controller.lowercaseBase32,
                        onChanged: widget.controller.setLowercaseBase32,
                      ),
                    ],
                  );
                },
              ),
              // Remove Padding Toggle
              ListenableBuilder(
                listenable: widget.controller,
                builder: (context, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Remove Padding'),
                      const SizedBox(width: 8),
                      Switch(
                        value: widget.controller.removePadding,
                        onChanged: widget.controller.setRemovePadding,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action Buttons Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: widget.controller.addUuid,
                icon: const Icon(Icons.add),
                label: Text(localizations.addUuid),
              ),
              ElevatedButton.icon(
                onPressed: () => widget.controller.addMultipleUuids(10),
                icon: const Icon(Icons.add_to_queue),
                label: Text(localizations.add10),
              ),
              ElevatedButton.icon(
                onPressed: widget.controller.clear,
                icon: const Icon(Icons.clear_all),
                label: Text(localizations.clearAll),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  widget.scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                },
                icon: const Icon(Icons.arrow_upward),
                label: Text(localizations.scrollToTop),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
