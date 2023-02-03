import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_task/bloc/recipes/recipes_cubit.dart';
import 'package:tech_task/models/recipe_model.dart';
import 'package:tech_task/repository/app_repository.dart';
import 'package:tech_task/widgets/recipe_item_widget.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<AppRepository>(context);
    final args = ModalRoute.of(context)?.settings.arguments;

    return BlocProvider(
      create: (context) => RecipesCubit(
        repository: repository,
        ingredients: args is List<String> ? args : [],
      ),
      child: _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesCubit, RecipesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 65,
            title: Column(
              children: [
                Text('Recipes'),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  state.ingredients.join(', '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.only(top: 15, bottom: 40),
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                child: RecipetItemWidget(
                  model: RecipeModel(
                    title: 'Recipe$i',
                    ingredients: ["Hotdog Bun", "Sausage", "Ketchup", "Mustard"],
                  ),
                ),
              );
            },
            itemCount: 10,
          ),
        );
      },
    );
  }
}
