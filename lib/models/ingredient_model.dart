import 'package:equatable/equatable.dart';

class IngredientModel extends Equatable {
  final String title;
  final DateTime useBy;

  IngredientModel({required this.title, required this.useBy});

  factory IngredientModel.fromJson(Map<String, dynamic> json) =>
      IngredientModel(title: json['title'], useBy: json['user_by']);

  @override
  List<Object?> get props => [title, useBy];
}
