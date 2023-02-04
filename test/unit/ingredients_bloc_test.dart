import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_task/bloc/ingredients/ingredients_cubit.dart';
import 'package:tech_task/models/ingredient_model.dart';
import 'package:tech_task/repository/app_repository.dart';
import 'package:tech_task/util/enums.dart';

import '../mocks.dart';

void main() {
  late AppRepository repository;
  final sampleLunchDate = DateTime(2000, 1, 2);
  final sampleErrorResponse = 'An error occurred';
  final sampleSuccessResponse = [
    IngredientModel(
      title: 'Ingredient1',
      useBy: sampleLunchDate,
    )
  ];

  setUp(() {
    repository = MockAppRepository();
  });

  blocTest(
    'emits Loading and Error status when fetch ingredients fail',
    build: () => IngredientsCubit(
        repository: repository, lunchDate: sampleLunchDate),
    act: (IngredientsCubit bloc) {
      when(() => repository.getIngredients()).thenAnswer(
        (_) => Future.value(BaseResponse.withError(sampleErrorResponse)),
      );
      bloc.fetchIngredients();
    },
    expect: () => [
      IngredientsState(
        fetchIngredientsStatus: LoadStatus.loading,
        message: '',
        ingredients: [],
        lunchDate: sampleLunchDate,
      ),
      IngredientsState(
        fetchIngredientsStatus: LoadStatus.error,
        message: sampleErrorResponse,
        ingredients: [],
        lunchDate: sampleLunchDate,
      ),
    ],
    verify: (_) {
      verify(() => repository.getIngredients()).called(1);
    },
  );

  blocTest(
    'emits Loading and Success status when fetch ingredients succeeds',
    build: () => IngredientsCubit(
        repository: repository, lunchDate: sampleLunchDate),
    act: (IngredientsCubit bloc) {
      when(() => repository.getIngredients()).thenAnswer(
        (_) => Future.value(
          BaseResponse.withData(sampleSuccessResponse),
        ),
      );
      bloc.fetchIngredients();
    },
    expect: () => [
      IngredientsState(
        fetchIngredientsStatus: LoadStatus.loading,
        message: '',
        ingredients: [],
        lunchDate: sampleLunchDate,
      ),
      IngredientsState(
        fetchIngredientsStatus: LoadStatus.success,
        message: '',
        ingredients: sampleSuccessResponse,
        lunchDate: sampleLunchDate,
      ),
    ],
    verify: (_) {
      verify(() => repository.getIngredients()).called(1);
    },
  );
}
