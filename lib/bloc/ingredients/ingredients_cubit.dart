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
}
