part of 'ingredients_cubit.dart';

class IngredientsState extends Equatable {
  final LoadStatus fetchIngredientsStatus;
  final String message;
  final List<IngredientModel> ingredients;
  final DateTime lunchDate;

  IngredientsState({
    required this.fetchIngredientsStatus,
    required this.message,
    required this.ingredients,
    required this.lunchDate,
  });

  IngredientsState copyWith({
    LoadStatus? fetchIngredients,
    String? message,
    List<IngredientModel>? ingredients,
    DateTime? lunchDate,
  }) =>
      IngredientsState(
        fetchIngredientsStatus: fetchIngredients ?? this.fetchIngredientsStatus,
        message: message ?? this.message,
        ingredients: ingredients ?? this.ingredients,
        lunchDate: lunchDate ?? this.lunchDate,
      );

  static IngredientsState initial(DateTime lunchDate) =>
      IngredientsState(
        fetchIngredientsStatus: LoadStatus.initial,
        message: '',
        ingredients: [],
        lunchDate: lunchDate,
      );

  @override
  List<Object?> get props =>
      [fetchIngredientsStatus, message, ingredients, lunchDate];
}
