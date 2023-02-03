part of 'recipes_cubit.dart';

class RecipesState extends Equatable {
  final LoadStatus fetchRecipesStatus;
  final String message;
  final List<RecipeModel> recipes;
  final List<String> ingredients;

  RecipesState({
    required this.fetchRecipesStatus,
    required this.message,
    required this.recipes,
    required this.ingredients,
  });

  RecipesState copyWith({
    LoadStatus? fetchRecipesStatus,
    String? message,
    List<RecipeModel>? recipes,
    List<String>? ingredients,
  }) =>
      RecipesState(
        fetchRecipesStatus: fetchRecipesStatus ?? this.fetchRecipesStatus,
        message: message ?? this.message,
        recipes: recipes ?? this.recipes,
        ingredients: ingredients ?? this.ingredients,
      );

  static RecipesState initial(List<String> ingredients) => RecipesState(
        fetchRecipesStatus: LoadStatus.initial,
        message: '',
        recipes: [],
        ingredients: ingredients,
      );

  @override
  List<Object?> get props =>
      [fetchRecipesStatus, message, recipes, ingredients];
}
