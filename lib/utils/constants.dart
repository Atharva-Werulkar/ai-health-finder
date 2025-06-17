import 'package:flutter_dotenv/flutter_dotenv.dart';

String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
String get mapApiKey => dotenv.env['MAP_API_KEY'] ?? '';
