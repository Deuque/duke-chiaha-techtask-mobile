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
}
