// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historymodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryModelImpl _$$HistoryModelImplFromJson(Map<String, dynamic> json) =>
    _$HistoryModelImpl(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$HistoryModelImplToJson(_$HistoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'items': instance.items?.map((e) => e.toJson()).toList(),
    };
