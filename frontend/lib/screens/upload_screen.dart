import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_app/services/api_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> with SingleTickerProviderStateMixin {
  File? _image;
  String _cropType = "Wheat";
  final picker = ImagePicker();
  bool _isUploading = false;
  String? _diseaseResult;

  late AnimationController _controller;
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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<void> _uploadAndDetectDisease() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('please_upload_image').tr()));
      return;
    }

    setState(() {
      _isUploading = true;
      _diseaseResult = null;
    });

    try {
      final result = await ApiService.uploadCropImageAndDetectDisease(_image!);
      setState(() => _diseaseResult = result['disease']);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('upload_failed').tr()));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('image_upload').tr(),
        backgroundColor: Colors.green[700],
      ),
      body: FadeTransition(
        opacity: _fadeIn,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Upload image for disease detection',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
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
                items: cropTypes.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
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
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file, size: 50, color: Colors.green[700]),
                            const SizedBox(height: 10),
                            Text('Tap to select image', style: TextStyle(fontSize: 16, color: Colors.green[900])),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, height: 220, fit: BoxFit.cover),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isUploading ? null : _uploadAndDetectDisease,
                child: _isUploading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('upload_and_detect').tr(),
              ),

              if (_diseaseResult != null) ...[
                const SizedBox(height: 20),
                Text('Detected Disease:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(_diseaseResult!, style: TextStyle(fontSize: 18, color: Colors.red[700])),
              ],
            ],
          ),
        ),
      ),
    );
  }
}






