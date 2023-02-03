import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tech_task/bloc/ingredients/ingredients_cubit.dart';
import 'package:tech_task/models/ingredient_model.dart';
import 'package:tech_task/repository/app_repository.dart';
import 'package:tech_task/routes.dart';
import 'package:tech_task/util/enums.dart';
import 'package:tech_task/widgets/custom_error_widget.dart';

import '../widgets/ingredient_item_widget.dart';

class IngredientsScreen extends StatelessWidget {
  const IngredientsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<AppRepository>(context);
    final args = ModalRoute.of(context)?.settings.arguments;

    return BlocProvider(
      create: (context) => IngredientsCubit(
        repository: repository,
        lunchDate: args is DateTime ? args : DateTime.now(),
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
  final _selectedIngredients = <IngredientModel>[];

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  void _fetchIngredients() {
    _selectedIngredients.clear();
    context.read<IngredientsCubit>().fetchIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        title: Column(
          crossAxisAlignment: Platform.isAndroid ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Text('Ingredients'),
            const SizedBox(
              height: 3,
            ),
            BlocBuilder<IngredientsCubit, IngredientsState>(
              builder: (context, state) {
                return Text(
                  DateFormat('dd MMM, yyyy').format(state.lunchDate),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _fetchIngredients(),
          child: BlocBuilder<IngredientsCubit, IngredientsState>(
            builder: (context, state) {
              if (state.fetchIngredientsStatus == LoadStatus.loading) {
                return Center(child: CircularProgressIndicator.adaptive());
              }
              if (state.fetchIngredientsStatus == LoadStatus.error) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: CustomErrorWidget(
                      onRefresh: _fetchIngredients,
                      message: state.message,
                    ),
                  ),
                );
              }
              if (state.fetchIngredientsStatus == LoadStatus.success) {
                if (state.ingredients.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: CustomErrorWidget(
                        onRefresh: _fetchIngredients,
                        message: 'No Ingredients found',
                      ),
                    ),
                  );
                }
                return _ingredientsListWidget(
                    state.ingredients, state.lunchDate);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _ingredientsListWidget(
      List<IngredientModel> ingredients, DateTime lunchDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 15, bottom: 40),
            itemBuilder: (_, i) {
              final ingredient = ingredients[i];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                child: IngredientItemWidget(
                  model: ingredient,
                  lunchDate: lunchDate,
                  onSelected: (_) => setState(() {
                    if (_selectedIngredients.contains(ingredient)) {
                      _selectedIngredients.remove(ingredient);
                    } else {
                      _selectedIngredients.add(ingredient);
                    }
                  }),
                  selected: _selectedIngredients.contains(ingredient),
                ),
              );
            },
            itemCount: ingredients.length,
          ),
        ),
        _getRecipesButton(),
      ],
    );
  }

  Widget _getRecipesButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 15,
        left: 20,
        right: 20,
      ),
      child: ElevatedButton(
        onPressed: _selectedIngredients.isEmpty
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  Routes.recipes,
                  arguments: _selectedIngredients.map((e) => e.title).toList(),
                );
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Get Recipes'),
            if (_selectedIngredients.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: Colors.white,
                  child: Text(
                    '${_selectedIngredients.length}',
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
