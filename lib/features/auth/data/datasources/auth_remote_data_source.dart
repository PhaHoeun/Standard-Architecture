import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/auth_user_model.dart';

part 'auth_remote_data_source.g.dart';

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSource(dio: dio);
}

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource({required this.dio});

  Future<AuthUserModel> fetchUserProfile(int userId) async {
    try {
      final response = await dio.get('/users/$userId');
      if (response.statusCode == 200) {
        return AuthUserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load user profile');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network connection error');
    }
  }
}
