import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_task/bloc/recipes/recipes_cubit.dart';
import 'package:tech_task/models/recipe_model.dart';
import 'package:tech_task/repository/app_repository.dart';
import 'package:tech_task/util/enums.dart';

import '../mocks.dart';

void main() {
  late AppRepository repository;
  final sampleIngredients = ['Chicken', 'Curry'];
  final sampleErrorResponse = 'An error occurred';
  final sampleSuccessResponse = [
    RecipeModel(
      title: 'Recipe1',
      ingredients: sampleIngredients,
    )
  ];

  setUp(() {
    repository = MockAppRepository();
  });

  blocTest(
    'emits Loading and Error status when fetch recipes fail',
    build: () => RecipesCubit(
      repository: repository,
      ingredients: sampleIngredients,
    ),
    act: (RecipesCubit bloc) {
      when(() => repository.getRecipes(sampleIngredients)).thenAnswer(
        (_) => Future.value(BaseResponse.withError(sampleErrorResponse)),
      );
      bloc.fetchRecipes();
    },
    expect: () => [
      RecipesState(
        fetchRecipesStatus: LoadStatus.loading,
        message: '',
        recipes: [],
        ingredients: sampleIngredients,
      ),
      RecipesState(
        fetchRecipesStatus: LoadStatus.error,
        message: sampleErrorResponse,
        recipes: [],
        ingredients: sampleIngredients,
      ),
    ],
    verify: (_) {
      verify(() => repository.getRecipes(sampleIngredients)).called(1);
    },
  );

  blocTest(
    'emits Loading and Error status when fetch recipes succeeds',
    build: () => RecipesCubit(
      repository: repository,
      ingredients: sampleIngredients,
    ),
    act: (RecipesCubit bloc) {
      when(() => repository.getRecipes(sampleIngredients)).thenAnswer(
        (_) => Future.value(BaseResponse.withData(sampleSuccessResponse)),
      );
      bloc.fetchRecipes();
    },
    expect: () => [
      RecipesState(
        fetchRecipesStatus: LoadStatus.loading,
        message: '',
        recipes: [],
        ingredients: sampleIngredients,
      ),
      RecipesState(
        fetchRecipesStatus: LoadStatus.success,
        message: '',
        recipes: sampleSuccessResponse,
        ingredients: sampleIngredients,
      ),
    ],
    verify: (_) {
      verify(() => repository.getRecipes(sampleIngredients)).called(1);
    },
  );
}
