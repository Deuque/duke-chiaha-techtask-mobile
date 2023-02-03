import 'package:equatable/equatable.dart';

class RecipeModel extends Equatable {
  final String title;
  final List<String> ingredients;

  RecipeModel({required this.title, required this.ingredients});

  factory RecipeModel.fromJson(Map json) => RecipeModel(
        title: json['title'],
        ingredients: List<String>.from(json['ingredients'] ?? []),
      );

  @override
  List<Object?> get props => [title, ingredients];
}
