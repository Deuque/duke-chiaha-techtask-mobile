import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_task/models/recipe_model.dart';
import 'package:tech_task/repository/app_repository.dart';
import 'package:tech_task/util/enums.dart';

part 'recipes_state.dart';

class RecipesCubit extends Cubit<RecipesState> {
  final AppRepository repository;

  RecipesCubit({required this.repository, required List<String> ingredients})
      : super(RecipesState.initial(ingredients));

  void fetchRecipes() async {
    emit(state.copyWith(fetchRecipesStatus: LoadStatus.loading));
    final response = await repository.getRecipes(state.ingredients);

    if (response.error != null) {
      emit(state.copyWith(
        fetchRecipesStatus: LoadStatus.error,
        message: response.error,
      ));
    } else if (response.data != null) {
      emit(state.copyWith(
        fetchRecipesStatus: LoadStatus.success,
        recipes: response.data,
      ));
    }
  }
}
