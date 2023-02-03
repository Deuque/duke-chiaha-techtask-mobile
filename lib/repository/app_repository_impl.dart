import 'package:tech_task/repository/app_repository.dart';

class AppRepositoryImpl extends AppRepository {
  final String baseUrl;

  AppRepositoryImpl(this.baseUrl);

  @override
  Future getIngredients() {
    throw UnimplementedError();
  }

  @override
  Future getRecipes(List<String> ingredients) {
    throw UnimplementedError();
  }
}
