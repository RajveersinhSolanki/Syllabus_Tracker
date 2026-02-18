import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:permission_handler/permission_handler.dart';

import 'notification_screen.dart';
import 'account_screen.dart';
import 'theme_provider.dart';
import 'syllabus_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // 🔽 IMPORT JSON
  Future<void> importJson(BuildContext context) async {
    final provider = Provider.of<SyllabusProvider>(context, listen: false);

    const XTypeGroup typeGroup = XTypeGroup(
      label: 'JSON',
      extensions: ['json'],
    );

    final XFile? file =
    await openFile(acceptedTypeGroups: [typeGroup]);

    if (file != null) {
      final jsonString = await file.readAsString();
      provider.importFromJson(jsonString);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("JSON Imported Successfully")),
      );
    }
  }

  // 🔼 EXPORT JSON (Save to REAL Download Folder)
  Future<void> exportJson(BuildContext context) async {
    final provider = Provider.of<SyllabusProvider>(context, listen: false);

    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.request();

      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission denied")),
        );
        return;
      }

      final directory = Directory('/storage/emulated/0/Download');

      final file = File('${directory.path}/syllabus_backup.json');

      await file.writeAsString(provider.exportToJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved to Download folder")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          // 🌙 DARK MODE
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            value: themeProvider.isDark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),

          const Divider(),

          // 📥 IMPORT JSON
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text("Import JSON"),
            onTap: () => importJson(context),
          ),

          // 📤 EXPORT JSON
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text("Export JSON"),
            onTap: () => exportJson(context),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Account"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AccountScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}