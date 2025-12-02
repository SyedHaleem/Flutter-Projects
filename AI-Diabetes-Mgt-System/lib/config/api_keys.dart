// Central place to access runtime API keys loaded via .env (do NOT commit secrets).
// Create a .env file at project root with:
// GEMINI_API_KEY=your_gemini_key
// USDA_API_KEY=your_usda_key
// (Never commit .env)  Add to .gitignore:  .env

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'api_keys_web.dart';

class ApiKeys {
	static String get gemini => kIsWeb ? ApiKeysWeb.gemini : dotenv.env['GEMINI_API_KEY'] ?? '';
	static String get usda => kIsWeb ? ApiKeysWeb.usda : dotenv.env['USDA_API_KEY'] ?? '';
}
