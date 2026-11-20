import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class CompanyModel with _$CompanyModel {
  const factory CompanyModel({
    @Default('') String name,
  }) = _CompanyModel;

  factory CompanyModel.fromJson(Map<String, dynamic> json) => _$CompanyModelFromJson(json);
}

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required int id,
    @Default('Unknown') String name,
    @Default('') String username,
    @Default('') String email,
    CompanyModel? company,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  User toEntity() => User(
        id: id,
        name: name,
        username: username,
        email: email,
        companyName: company?.name ?? 'N/A',
      );
}
