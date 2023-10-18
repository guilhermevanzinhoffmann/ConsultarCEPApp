import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomViaCEPDio {
  final Dio _dio = Dio();

  Dio get dio => _dio;

  CustomViaCEPDio() {
    _dio.options.baseUrl = dotenv.get("VIACEP_BASE_URL");
  }
}
