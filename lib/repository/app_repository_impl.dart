import 'dart:convert';

import 'package:tech_task/models/ingredient_model.dart';
import 'package:tech_task/models/recipe_model.dart';
import 'package:tech_task/repository/app_repository.dart';
import 'package:http/http.dart' as http;

class AppRepositoryImpl extends AppRepository {
  final String baseUrl;
  final http.Client client;

  AppRepositoryImpl(this.baseUrl) : client = http.Client();

  @override
  Future<BaseResponse<List<IngredientModel>>> getIngredients() async {
    try {
      final url = Uri.parse('$baseUrl/ingredients');
      final response = await client.get(url);
      if (response.statusCode != 200) {
        throw response.body;
      }
      final data = jsonDecode(response.body);
      final ingredients =
          List<Map>.from(data).map(IngredientModel.fromJson).toList();
      return BaseResponse.withData(ingredients);
    } catch (e) {
      return BaseResponse.withError('$e');
    }
  }

  @override
  Future<BaseResponse<List<RecipeModel>>> getRecipes(
      List<String> ingredients) async {
    try {
      final url =
          Uri.parse('$baseUrl/recipes?ingredients=${ingredients.join(',')}');
      final response = await client.get(url);
      if (response.statusCode != 200) {
        throw response.body;
      }
      final data = jsonDecode(response.body);
      final recipes = List<Map>.from(data).map(RecipeModel.fromJson).toList();
      return BaseResponse.withData(recipes);
    } catch (e) {
      return BaseResponse.withError('$e');
    }
  }
}
