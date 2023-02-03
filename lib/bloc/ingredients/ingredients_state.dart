part of 'ingredients_cubit.dart';

class IngredientsState extends Equatable {
  final LoadState fetchIngredients;
  final String message;
  final List<IngredientModel> ingredients;
  final DateTime lunchDate;

  IngredientsState({
    required this.fetchIngredients,
    required this.message,
    required this.ingredients,
    required this.lunchDate,
  });

  IngredientsState copyWith({
    LoadState? fetchIngredients,
    String? message,
    List<IngredientModel>? ingredients,
    DateTime? lunchDate,
  }) =>
      IngredientsState(
        fetchIngredients: fetchIngredients ?? this.fetchIngredients,
        message: message ?? this.message,
        ingredients: ingredients ?? this.ingredients,
        lunchDate: lunchDate ?? this.lunchDate,
      );

  static IngredientsState initial(DateTime lunchDate) =>
      IngredientsState(
        fetchIngredients: LoadState.initial,
        message: '',
        ingredients: [],
        lunchDate: lunchDate,
      );

  @override
  List<Object?> get props =>
      [fetchIngredients, message, ingredients, lunchDate];
}
