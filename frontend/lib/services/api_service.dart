import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL of your backend
  static const String baseUrl = "https://7df1e5062d7a.ngrok-free.app";

  /// Sends soil data to backend
  static Future<void> sendSoilData({
    required double ph,
    required double moisture,
    required String nutrient,
    required String previousCrop,
    required String location,
    required double temperature,
    required double humidity,
    required double rainfall,
    required String season,
    required double area,
    required double fertilizer,
    required double pesticide,
  }) async {
    final url = Uri.parse("$baseUrl/soil-data");

    final payload = {
      "ph": ph,
      "moisture": moisture,
      "nutrient": nutrient,
      "previous_crop": previousCrop,
      "location": location,
      "temperature": temperature,
      "humidity": humidity,
      "rainfall": rainfall,
      "season": season,
      "area": area,
      "fertilizer": fertilizer,
      "pesticide": pesticide,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to send soil data: ${response.statusCode} - ${response.body}");
    }
  }

  /// Uploads a crop image and gets detected disease from backend
  static Future<Map<String, dynamic>> uploadCropImageAndDetectDisease(File imageFile) async {
    final uri = Uri.parse("https://eee1af7d1a14.ngrok-free.app/detect-disease");

    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr); // Expected: {"disease": "Leaf Blight"}
    } else {
      throw Exception("Failed to upload image. Status code: ${response.statusCode}");
    }
  }

  /// Fetches crop recommendations from backend
  static Future<List<Map<String, dynamic>>> fetchRecommendations() async {
    final url = Uri.parse("https://eee1af7d1a14.ngrok-free.app/recommend-crop");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception("Failed to fetch recommendations: ${response.statusCode}");
    }
  }

  /// Sends a question to backend AI and gets answer
  static Future<String> askQuestion(String question) async {
    final url = Uri.parse("$baseUrl/ask");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"question": question}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['answer'] ?? "No answer found";
    } else {
      throw Exception("Failed to fetch answer: ${response.statusCode}");
    }
  }
}


