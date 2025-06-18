import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';

String get geminiApiKey {
  try {
    final key = dotenv.env['GEMINI_API_KEY'];
    if (key == null || key.isEmpty) {
      log('Warning: GEMINI_API_KEY not found in .env file');
      return '';
    }
    return key;
  } catch (e) {
    log('Error accessing GEMINI_API_KEY: $e');
    return '';
  }
}

String get mapApiKey {
  try {
    final key = dotenv.env['MAP_API_KEY'];
    if (key == null || key.isEmpty) {
      log('Warning: MAP_API_KEY not found in .env file');
      return '';
    }
    return key;
  } catch (e) {
    log('Error accessing MAP_API_KEY: $e');
    return '';
  }
}

// Helper function to check if API keys are properly loaded
bool get areApiKeysLoaded {
  return geminiApiKey.isNotEmpty && mapApiKey.isNotEmpty;
}
