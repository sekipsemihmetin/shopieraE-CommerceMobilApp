import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseInfo {
  static const String appName = 'Shopiera App';
  static const String version = '1.0.0';
  static const String packageName = 'com.example.shopiera';
  static const String buildNumber = '1';
  static const String username = 'sekip_metin';

  static String apiUrl = dotenv.env['API_URL'] ?? 'http://kasimadalan.pe.hu';
  static String imageUrl = '$apiUrl/urunler/resimler';
}
