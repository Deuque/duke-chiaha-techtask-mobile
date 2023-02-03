import 'package:flutter/widgets.dart';
import 'package:tech_task/screens/home_screen.dart';
import 'package:tech_task/screens/ingredients_screen.dart';
import 'package:tech_task/screens/recipes_screen.dart';

class Routes {
  static const home = "home";
  static const ingredients = "ingredients";
  static const recipes = "recipes";

  static Map<String, WidgetBuilder> generateRoutes() => {
        home: (context) => HomeScreen(),
        ingredients: (context) => IngredientsScreen(),
        recipes: (context) => RecipesScreen(),
      };
}
