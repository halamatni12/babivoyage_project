import 'package:dio/dio.dart';

class AuthApi {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2/babibeauty_api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        'login.php',
        data: {
          'email': email,
          'password': password,
        },
      );

      return response.data;
    } on DioException catch (e) {
      return {
        "status": "error",
        "message": e.response?.data ?? "Network error"
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Something went wrong"
      };
    }
  }
}