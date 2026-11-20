import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

part 'auth_repository_impl.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthUser? _cachedUser;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthUser?> getCurrentUser() async {
    if (_cachedUser != null) return _cachedUser;
    try {
      // Default initial mock logged-in user (User ID 1)
      final model = await remoteDataSource.fetchUserProfile(1);
      _cachedUser = model.toEntity();
      return _cachedUser;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<AuthUser> login({required String email, required String password}) async {
    // Simulated network authentication
    final model = await remoteDataSource.fetchUserProfile(1);
    _cachedUser = model.toEntity();
    return _cachedUser!;
  }

  @override
  Future<void> logout() async {
    _cachedUser = null;
  }
}
