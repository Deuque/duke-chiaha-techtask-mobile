import 'package:tech_task/models/ingredient_model.dart';
import 'package:tech_task/models/recipe_model.dart';

abstract class AppRepository {
  Future<BaseResponse<List<IngredientModel>>> getIngredients();

  Future<BaseResponse<List<RecipeModel>>> getRecipes(List<String> ingredients);
}

class BaseResponse<T> {
  final String? error;
  final T? data;

  BaseResponse.withError(String error)
      : this.error = error,
        this.data = null;

  BaseResponse.withData(T data)
      : this.data = data,
        this.error = null;
}
