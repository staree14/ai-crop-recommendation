import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> with SingleTickerProviderStateMixin {
  File? _image;
  String _cropType = "Wheat";
  final picker = ImagePicker();

  String? _diseaseResult;
  List<String>? _diseaseSolutions;

  late AnimationController _fadeController;
  late Animation<double> _fadeIn;

  final List<String> cropTypes = [
    "Wheat",
    "Rice",
    "Maize",
    "Vegetables",
    "Pulses",
    "Fruits",
    "Others"
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);

        // Immediately show predefined disease result
        _diseaseResult = "Late Blight";
        _diseaseSolutions = [
          "Apply a targeted fungicide (chlorothalonil or copper-based)",
          "Remove infected leaves",
          "Ensure good air circulation",
          "Water at the base of the plant to keep foliage dry"
        ];

        _fadeController.reset();
        _fadeController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('image_upload').tr(),
        backgroundColor: Colors.green[600],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Upload image for disease detection',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _cropType,
              decoration: InputDecoration(
                labelText: 'Crop Type'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.green[50],
              ),
              items: cropTypes
                  .map((e) => DropdownMenuItem(child: Text(e), value: e))
                  .toList(),
              onChanged: (val) => setState(() => _cropType = val!),
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: _image == null
                    ? Center(
                        child: Text(
                          'Tap to select image',
                          style: TextStyle(
                              fontSize: 16, color: Colors.green[900]),
                        ),
                      )
                    : FadeTransition(
                        opacity: _fadeIn,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, height: 220, fit: BoxFit.cover),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            if (_diseaseResult != null) ...[
              FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Detected Disease:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(_diseaseResult!,
                        style: TextStyle(fontSize: 18, color: Colors.red[700])),
                    const SizedBox(height: 10),
                    Text('Solutions:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    for (var sol in _diseaseSolutions!)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text("• $sol",
                            style: TextStyle(fontSize: 14, color: Colors.green[900])),
                      ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}















