abstract class AppRepository{
  Future getIngredients();
  Future getRecipes(List<String> ingredients);
}