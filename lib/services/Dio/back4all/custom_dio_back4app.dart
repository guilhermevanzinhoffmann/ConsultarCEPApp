import 'package:cepapp/services/Dio/back4all/custom_dio_back4all_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomDioBack4App {
  final _dio = Dio();

  Dio get dio => _dio;

  CustomDioBack4App() {
    _dio.options.baseUrl = dotenv.get("BACK4ALL_BASE_URL");
    _dio.interceptors.add(CustomDioBack4AllInterceptor());
  }
}
