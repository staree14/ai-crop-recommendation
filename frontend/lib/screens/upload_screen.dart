import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  String _cropType = "Wheat";
  final picker = ImagePicker();

  String? _diseaseResult;
  List<String>? _diseaseSolutions;

  final List<String> cropTypes = [
    "Wheat",
    "Rice",
    "Maize",
    "Vegetables",
    "Pulses",
    "Fruits",
    "Others"
  ];

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);

        // Predefined disease result
        _diseaseResult = "Late Blight";
        _diseaseSolutions = [
          "Apply a targeted fungicide (chlorothalonil or copper-based)",
          "Remove infected leaves",
          "Ensure good air circulation",
          "Water at the base of the plant to keep foliage dry"
        ];
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
            // Top message
            Text(
              'Please upload image to detect disease',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Crop type dropdown
            DropdownButtonFormField<String>(
              value: _cropType,
              decoration: InputDecoration(
                labelText: 'Crop Type'.tr(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.green[50],
              ),
              items: cropTypes
                  .map((e) => DropdownMenuItem(child: Text(e), value: e))
                  .toList(),
              onChanged: (val) => setState(() => _cropType = val!),
            ),
            const SizedBox(height: 20),

            // Image picker
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
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_rounded,
                              size: 60, color: Colors.green[700]),
                          SizedBox(height: 12),
                          Text(
                            'Upload image to detect',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.green[900],
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_image!,
                            height: 220, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Disease result card
            if (_diseaseResult != null) ...[
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.orange[700]),
                          SizedBox(width: 8),
                          Text(
                            'Detected Disease',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        _diseaseResult!,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700]),
                      ),
                      SizedBox(height: 12),
                      Text('Solutions:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      for (var sol in _diseaseSolutions!)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text("• $sol",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.green[900])),
                        ),
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}









