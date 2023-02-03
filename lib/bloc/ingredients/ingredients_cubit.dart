import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_task/models/ingredient_model.dart';
import 'package:tech_task/repository/app_repository.dart';
import 'package:tech_task/util/enums.dart';

part 'ingredients_state.dart';

class IngredientsCubit extends Cubit<IngredientsState> {
  final AppRepository repository;

  IngredientsCubit({required this.repository, required DateTime lunchDate})
      : super(IngredientsState.initial(lunchDate));

  void fetchIngredients() async {
    emit(state.copyWith(fetchIngredientsStatus: LoadStatus.loading));
    final response = await repository.getIngredients();

    if (response.error != null) {
      emit(state.copyWith(
        fetchIngredientsStatus: LoadStatus.error,
        message: response.error,
      ));
    } else if (response.data != null) {
      emit(state.copyWith(
        fetchIngredientsStatus: LoadStatus.success,
        ingredients: response.data,
      ));
    }
  }
}
