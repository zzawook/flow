import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/domain/entities/entities.dart';

part 'user_state_model.freezed.dart';

@freezed
class UserStateModel with _$UserStateModel {
  const factory UserStateModel({
    required User user,
  }) = _UserStateModel;

  factory UserStateModel.initial() => UserStateModel(
    user: User.initial(),
  );
}