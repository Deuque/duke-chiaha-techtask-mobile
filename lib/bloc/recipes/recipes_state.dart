part of 'recipes_cubit.dart';

class RecipesState extends Equatable {
  final LoadStatus fetchRecipientsStatus;
  final String message;
  final List<RecipeModel> recipes;
  final List<String> ingredients;

  RecipesState({
    required this.fetchRecipientsStatus,
    required this.message,
    required this.recipes,
    required this.ingredients,
  });

  RecipesState copyWith({
    LoadStatus? fetchRecipientsStatus,
    String? message,
    List<RecipeModel>? recipes,
    List<String>? ingredients,
  }) =>
      RecipesState(
        fetchRecipientsStatus:
            fetchRecipientsStatus ?? this.fetchRecipientsStatus,
        message: message ?? this.message,
        recipes: recipes ?? this.recipes,
        ingredients: ingredients ?? this.ingredients,
      );

  static RecipesState initial(List<String> ingredients) => RecipesState(
        fetchRecipientsStatus: LoadStatus.initial,
        message: '',
        recipes: [],
        ingredients: ingredients,
      );

  @override
  List<Object?> get props =>
      [fetchRecipientsStatus, message, recipes, ingredients];
}
