import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_task/bloc/recipes/recipes_cubit.dart';
import 'package:tech_task/models/recipe_model.dart';
import 'package:tech_task/repository/app_repository.dart';
import 'package:tech_task/util/enums.dart';
import 'package:tech_task/widgets/custom_error_widget.dart';
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

class _View extends StatefulWidget {
  const _View({Key? key}) : super(key: key);

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  void _fetchRecipes() {
    context.read<RecipesCubit>().fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        title: Column(
          crossAxisAlignment: Platform.isAndroid
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Text('Recipes'),
            const SizedBox(
              height: 3,
            ),
            BlocBuilder<RecipesCubit, RecipesState>(builder: (context, state) {
              return Text(
                state.ingredients.join(', '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              );
            }),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _fetchRecipes(),
          child: BlocBuilder<RecipesCubit, RecipesState>(
            builder: (context, state) {
              if (state.fetchRecipesStatus == LoadStatus.loading) {
                return Center(child: CircularProgressIndicator.adaptive());
              }
              if (state.fetchRecipesStatus == LoadStatus.error) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: CustomErrorWidget(
                      onRefresh: _fetchRecipes,
                      message: state.message,
                    ),
                  ),
                );
              }
              if (state.fetchRecipesStatus == LoadStatus.success) {
                if (state.ingredients.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: CustomErrorWidget(
                        onRefresh: _fetchRecipes,
                        message: 'No Recipes found',
                      ),
                    ),
                  );
                }
                return _recipesListWidget(state.recipes);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _recipesListWidget(List<RecipeModel> recipes) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 15, bottom: 40),
      itemBuilder: (_, i) {
        final recipe = recipes[i];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          child: RecipeItemWidget(
            model: recipe,
          ),
        );
      },
      itemCount: recipes.length,
    );
  }
}
