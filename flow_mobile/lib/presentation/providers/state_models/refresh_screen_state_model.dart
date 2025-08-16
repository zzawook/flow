import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/domain/entities/entities.dart';

part 'refresh_screen_state_model.freezed.dart';

@freezed
class RefreshScreenStateModel with _$RefreshScreenStateModel {
  const factory RefreshScreenStateModel({
    @Default([]) List<Bank> banksToRefresh,
  }) = _RefreshScreenStateModel;

  factory RefreshScreenStateModel.initial() => const RefreshScreenStateModel();
}