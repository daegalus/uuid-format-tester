/// Main view for displaying UUID encodings in various formats.
library;

import 'package:flutter/material.dart';

import '../constants/alphabets.dart';
import '../controllers/uuid_list_controller.dart';
import '../localization/app_localizations.dart';
import '../services/uuid_encoding_service.dart';
import '../settings/settings_controller.dart';
import '../widgets/uuid_controls_panel.dart';
import '../widgets/uuid_data_table.dart';

/// Displays a list of UUIDs encoded in various formats.
class UuidFormatView extends StatefulWidget {
  const UuidFormatView({
    required this.settingsController,
    super.key,
  });

  final SettingsController settingsController;

  static const routeName = '/';

  @override
  State<UuidFormatView> createState() => _UuidFormatViewState();
}

class _UuidFormatViewState extends State<UuidFormatView> {
  late final UuidListController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = UuidListController(UuidEncodingService());
    // Add the reference UUID for testing
    _controller.addSpecificUuid(referenceUuid);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        centerTitle: true,
        actions: [
          // Language picker
          PopupMenuButton<Locale?>(
            icon: const Icon(Icons.language),
            tooltip: 'Language',
            onSelected: (Locale? locale) {
              widget.settingsController.updateLocale(locale);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<Locale?>(
                value: null,
                child: Text('🌐 Auto (System)'),
              ),
              const PopupMenuItem<Locale?>(
                enabled: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '✨ AI-Generated Translations',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('en', ''),
                child: Text('🇬🇧 English'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('da', ''),
                child: Text('✨ 🇩🇰 Danish'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('bg', ''),
                child: Text('✨ 🇧🇬 Bulgarian'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('ru', ''),
                child: Text('✨ 🇷🇺 Russian'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('ja', ''),
                child: Text('✨ 🇯🇵 Japanese'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('ko', ''),
                child: Text('✨ 🇰🇷 Korean'),
              ),
            ],
          ),
          // Theme mode picker
          PopupMenuButton<ThemeMode>(
            icon: Icon(
              widget.settingsController.themeMode == ThemeMode.light
                  ? Icons.light_mode
                  : widget.settingsController.themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.brightness_auto,
            ),
            tooltip: 'Theme',
            onSelected: (ThemeMode mode) {
              widget.settingsController.updateThemeMode(mode);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Row(
                  children: [
                    Icon(Icons.brightness_auto),
                    SizedBox(width: 8),
                    Text('System'),
                  ],
                ),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Row(
                  children: [
                    Icon(Icons.light_mode),
                    SizedBox(width: 8),
                    Text('Light'),
                  ],
                ),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Row(
                  children: [
                    Icon(Icons.dark_mode),
                    SizedBox(width: 8),
                    Text('Dark'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          UuidControlsPanel(
            controller: _controller,
            scrollController: _scrollController,
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                return UuidDataTable(items: _controller.items);
              },
            ),
          ),
        ],
      ),
    );
  }
}
