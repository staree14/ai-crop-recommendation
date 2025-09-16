import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 16;
  bool _highContrast = false;
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? 16;
      _highContrast = prefs.getBool('highContrast') ?? false;
      _language = prefs.getString('language') ?? 'en';
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setBool('highContrast', _highContrast);
    await prefs.setString('language', _language);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings saved successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green[600],
      ),
    );
  }

  void _changeLanguage(String code) {
    context.setLocale(Locale(code));
    setState(() => _language = code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Font Size',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Slider(
              min: 12,
              max: 24,
              divisions: 12,
              value: _fontSize,
              label: _fontSize.toStringAsFixed(0),
              activeColor: Colors.green,
              onChanged: (val) => setState(() => _fontSize = val),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('High Contrast', style: TextStyle(fontSize: 16)),
                Switch(
                  value: _highContrast,
                  activeColor: Colors.green,
                  onChanged: (val) => setState(() => _highContrast = val),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Language',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _language,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: [
                DropdownMenuItem(child: Text('English'), value: 'en'),
                DropdownMenuItem(child: Text('Hindi'), value: 'hi'),
                DropdownMenuItem(child: Text('Kannada'), value: 'kn'),
                DropdownMenuItem(child: Text('Odia'), value: 'or'),
              ],
              onChanged: (val) {
                if (val != null) _changeLanguage(val);
              },
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _saveSettings,
                child: Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
