import 'package:dio/dio.dart';
import '../constants/base_constants.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: BaseInfo.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.formUrlEncodedContentType,
    ),
  );
}
