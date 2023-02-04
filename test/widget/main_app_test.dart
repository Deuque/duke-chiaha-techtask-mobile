import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_task/main.dart';
import 'package:tech_task/models/ingredient_model.dart';
import 'package:tech_task/models/recipe_model.dart';
import 'package:tech_task/repository/app_repository.dart';
import 'package:tech_task/screens/home_screen.dart';
import 'package:tech_task/screens/ingredients_screen.dart';
import 'package:tech_task/screens/recipes_screen.dart';

import '../mocks.dart';

void main() {
  final sampleLunchDate = DateTime.now();
  final sampleIngredientsSuccessResponse = [
    IngredientModel(
      title: 'Ingredient1',
      useBy: sampleLunchDate,
    )
  ];
  final sampleIngredients = ['Chicken', 'Curry'];
  final sampleRecipesSuccessResponse = [
    RecipeModel(
      title: 'Recipe1',
      ingredients: sampleIngredients,
    )
  ];

  testWidgets("End-to-end test of flow, Happy Path", (tester) async {
    final repository = MockAppRepository();
    when(() => repository.getIngredients()).thenAnswer(
      (_) => Future.value(
        BaseResponse.withData(sampleIngredientsSuccessResponse),
      ),
    );
    when(() => repository.getRecipes(any())).thenAnswer(
      (_) => Future.value(BaseResponse.withData(sampleRecipesSuccessResponse)),
    );

    await tester.pumpWidget(MyApp(repository: repository));

    // expects to see Homescreen loaded
    await tester.pumpAndSettle(Duration(milliseconds: 1500));
    expect(find.byType(HomeScreen), findsOneWidget);

    // tap 'Get Ingredients' button
    await tester.tap(
      find.descendant(
        of: find.byType(HomeScreen),
        matching: find.byKey(HomeScreenKeys.getIngredientsButton),
      ),
    );

    // expects to see IngredientsScreen and Ingredients List loaded
    await tester.pumpAndSettle();
    expect(find.byType(IngredientsScreen), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(IngredientsScreen),
        matching: find.byKey(IngredientsScreenKeys.ingredientsList),
      ),
      findsOneWidget,
    );

    // tap to select Ingredient
    await tester.tap(
      find.descendant(
        of: find.byType(IngredientsScreen),
        matching: find.text(sampleIngredientsSuccessResponse.first.title),
      ),
    );

    // ensure that ingredient is selected,
    // by making sure selection count is visible
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(IngredientsScreen),
        matching: find.byKey(IngredientsScreenKeys.selectionCount),
      ),
      findsOneWidget,
    );

    // tap 'Get Recipes' button
    await tester.tap(
      find.descendant(
        of: find.byType(IngredientsScreen),
        matching: find.byKey(IngredientsScreenKeys.getRecipesButton),
      ),
    );

    // expects to see RecipesScreen and Recipes List loaded
    await tester.pumpAndSettle();
    expect(find.byType(RecipesScreen), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(RecipesScreen),
        matching: find.byKey(RecipesScreenKeys.recipesList),
      ),
      findsOneWidget,
    );

    // tap Recipe item to reveal ingredients
    await tester.tap(
      find.descendant(
        of: find.byType(RecipesScreen),
        matching: find.text(sampleRecipesSuccessResponse.first.title),
      ),
    );
    await tester.pumpAndSettle();
    for (final ingredient in sampleRecipesSuccessResponse.first.ingredients) {
      expect(
        find.descendant(
          of: find.byType(RecipesScreen),
          matching: find.text(ingredient),
        ),
        findsOneWidget,
      );
    }
  });
}
