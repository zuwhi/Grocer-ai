
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:green_cart_scanner/model/items/item.dart';

part 'historymodel.freezed.dart';
part 'historymodel.g.dart';

@unfreezed
class HistoryModel with _$HistoryModel {
  @JsonSerializable(explicitToJson: true)
  factory HistoryModel({
    @Default('') String id,
    @Default('') String? date,
    @JsonKey(name: 'items') List<Item>? items,
  }) = _HistoryModel;
	
  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
			_$HistoryModelFromJson(json);
}
