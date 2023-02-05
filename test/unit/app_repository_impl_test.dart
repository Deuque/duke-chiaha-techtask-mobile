import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tech_task/models/ingredient_model.dart';
import 'package:tech_task/models/recipe_model.dart';
import 'package:tech_task/repository/app_repository.dart';
import 'package:tech_task/repository/app_repository_impl.dart';

import '../mocks.dart';

void main() {
  late http.Client client;
  late AppRepositoryImpl repository;
  final mockBaseUrl = 'https://test.com';

  setUp(() {
    client = MockHttpClient();
    repository = AppRepositoryImpl(baseUrl: mockBaseUrl, client: client);
  });

  group('Fetch Ingredients', () {
    test('Wrong status code throws error', () async {
      when(() => client.get(Uri.parse(repository.ingredientsEndpoint)))
          .thenAnswer(
        (_) => Future.value(
          http.Response('An error occurred', 400),
        ),
      );

      expect(
        await repository.getIngredients(),
        BaseResponse<List<IngredientModel>>.withError('An error occurred'),
      );
    });

    test('Wrong response data type throws error', () async {
      when(() => client.get(Uri.parse(repository.ingredientsEndpoint)))
          .thenAnswer(
        (_) => Future.value(
          http.Response(json.encode('Wrong body type'), 200),
        ),
      );

      expect(
        await repository.getIngredients(),
        BaseResponse<List<IngredientModel>>.withError(
            repository.invalidResponseError),
      );
    });

    test('Succeeds when response has right status code and data type',
        () async {
      final response = [
        {
          'title': 'Ingredient1',
          'use-by': '2000-01-02',
        }
      ];
      when(() => client.get(Uri.parse(repository.ingredientsEndpoint)))
          .thenAnswer(
        (_) => Future.value(
          http.Response(json.encode(response), 200),
        ),
      );

      expect(
        await repository.getIngredients(),
        BaseResponse<List<IngredientModel>>.withData(
          response.map(IngredientModel.fromJson).toList(),
        ),
      );
    });
  });

  group('Fetch Recipes', () {
    final ingredients = ['Bread', 'Cheese'];
    test('Wrong status code throws error', () async {
      when(() => client.get(Uri.parse(repository.recipesEndpoint(ingredients))))
          .thenAnswer(
        (_) => Future.value(
          http.Response('An error occurred', 400),
        ),
      );

      expect(
        await repository.getRecipes(ingredients),
        BaseResponse<List<RecipeModel>>.withError('An error occurred'),
      );
    });

    test('Wrong response data type throws error', () async {
      when(() => client.get(Uri.parse(repository.recipesEndpoint(ingredients))))
          .thenAnswer(
        (_) => Future.value(
          http.Response(json.encode('Wrong body type'), 200),
        ),
      );

      expect(
        await repository.getRecipes(ingredients),
        BaseResponse<List<RecipeModel>>.withError(
            repository.invalidResponseError),
      );
    });

    test('Succeeds when response has right status code and data type',
        () async {
      final response = [
        {
          'title': 'Recipe1',
          'ingredients': ingredients,
        }
      ];
      when(() => client.get(Uri.parse(repository.recipesEndpoint(ingredients))))
          .thenAnswer(
        (_) => Future.value(
          http.Response(json.encode(response), 200),
        ),
      );

      expect(
        await repository.getRecipes(ingredients),
        BaseResponse<List<RecipeModel>>.withData(
          response.map(RecipeModel.fromJson).toList(),
        ),
      );
    });
  });
}
