import 'package:equatable/equatable.dart';

class IngredientModel extends Equatable {
  final String title;
  final DateTime useBy;

  IngredientModel({required this.title, required this.useBy});

  factory IngredientModel.fromJson(Map json) => IngredientModel(
        title: json['title'],
        useBy: json['use-by'] == null
            ? DateTime.now()
            : DateTime.parse(json['use-by']),
      );

  @override
  List<Object?> get props => [title, useBy];
}
