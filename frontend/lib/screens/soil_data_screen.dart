import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SoilDataScreen extends StatefulWidget {
  const SoilDataScreen({super.key});

  @override
  _SoilDataScreenState createState() => _SoilDataScreenState();
}

class _SoilDataScreenState extends State<SoilDataScreen> with SingleTickerProviderStateMixin {
  double _moisture = 50;
  String _nutrient = "NPK";
  String _previousCrop = "Wheat";
  String _state = "Fetching...";
  String _district = "Fetching...";
  String _season = "Kharif";
  double _area = 1;
  double _fertilizer = 50;
  double _pesticide = 5;

  double _temperature = 0;
  double _humidity = 0;
  double _rainfall = 0;

  bool _loading = true;

  final List<String> nutrientsList = ["NPK", "Organic", "Compost", "Bio-Fertilizer", "None"];
  final List<String> previousCrops = ["Wheat", "Rice", "Maize", "Vegetables", "Pulses", "Flowers", "None", "Others"];
  final List<String> seasons = ["Kharif", "Rabi", "Zaid"];

  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  // Hardcoded coordinates (Bangalore)
  final double latitude = 13.056022;
  final double longitude = 77.443695;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();

    _loadSavedData();
    _getLocationAndWeather();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _moisture = prefs.getDouble('moisture') ?? 50;
      _nutrient = prefs.getString('nutrient') ?? "NPK";
      _previousCrop = prefs.getString('previousCrop') ?? "Wheat";
      _season = prefs.getString('season') ?? "Kharif";
      _area = prefs.getDouble('area') ?? 1;
      _fertilizer = prefs.getDouble('fertilizer') ?? 50;
      _pesticide = prefs.getDouble('pesticide') ?? 5;
    });
  }

  Future<void> _saveOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('moisture', _moisture);
    await prefs.setString('nutrient', _nutrient);
    await prefs.setString('previousCrop', _previousCrop);
    await prefs.setString('state', _state);
    await prefs.setString('season', _season);
    await prefs.setDouble('area', _area);
    await prefs.setDouble('fertilizer', _fertilizer);
    await prefs.setDouble('pesticide', _pesticide);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data saved offline!').tr()),
    );
  }

  Future<void> _getLocationAndWeather() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        _state = placemarks.first.administrativeArea ?? "Unknown";
        _district = placemarks.first.subAdministrativeArea ?? "Unknown";
      } else {
        _state = "Unknown";
        _district = "Unknown";
      }

      final weather = await _getWeatherData(latitude, longitude);
      _temperature = weather['temperature']!;
      _humidity = weather['humidity']!;
      _rainfall = weather['rainfall']!;
    } catch (e) {
      print("Error fetching location or weather: $e");
      _state = "Error fetching data";
      _district = "Error fetching data";
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<Map<String, double>> _getWeatherData(double lat, double lon) async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=59f81a0be4dcc5e1678fcd2f8eaabe0b&units=metric");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      double rainfall = 0.0;
      if (data.containsKey('rain') && data['rain'] is Map<String, dynamic>) {
        rainfall = (data['rain']['1h'] ?? data['rain']['3h'] ?? 0).toDouble();
      }

      return {
        "temperature": (data['main']['temp'] ?? 0).toDouble(),
        "humidity": (data['main']['humidity'] ?? 0).toDouble(),
        "rainfall": rainfall,
      };
    } else {
      return {
        "temperature": 0,
        "humidity": 0,
        "rainfall": 0,
      };
    }
  }

  Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soilDataSubmitted', true);  // <-- Add this

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data submitted successfully!').tr()),
    );

    // Optional: Navigate back or refresh Recommendations screen
    Navigator.pop(context);  // if you want to return to recommendations immediately
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('soil_data').tr(),
        backgroundColor: Colors.green[700],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeIn,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        color: Colors.green[50],
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.symmetric(vertical: 12),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Location Information",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.green[800])),
                              SizedBox(height: 8),
                              Text("District: $_district",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text("State: $_state",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text("Temperature: ${_temperature.toStringAsFixed(1)} °C"),
                              Text("Humidity: ${_humidity.toStringAsFixed(1)}%"),
                              Text(
                                  "Rainfall: ${_rainfall > 0 ? '${_rainfall.toStringAsFixed(1)} mm' : 'No rain data available'}"),
                            ],
                          ),
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: _season,
                        decoration: InputDecoration(
                          labelText: 'Season'.tr(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        items: seasons
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (val) => setState(() => _season = val!),
                      ),
                      SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _nutrient,
                        decoration: InputDecoration(
                          labelText: 'nutrients'.tr(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        items: nutrientsList
                            .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                            .toList(),
                        onChanged: (val) => setState(() => _nutrient = val!),
                      ),
                      SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _previousCrop,
                        decoration: InputDecoration(
                          labelText: 'previous_crop'.tr(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        items: previousCrops
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) => setState(() => _previousCrop = val!),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[500],
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _submitForm,
                        child: Text('submit').tr(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

