import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tech_task/bloc/ingredients/ingredients_cubit.dart';
import 'package:tech_task/models/ingredient_model.dart';
import 'package:tech_task/repository/app_repository.dart';
import 'package:tech_task/routes.dart';

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
  final _selectedIngredients = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IngredientsCubit, IngredientsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 65,
            title: Column(
              children: [
                Text('Ingredients'),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  DateFormat('dd MMM, yyyy').format(state.lunchDate),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 15, bottom: 40),
                    itemBuilder: (_, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 7),
                        child: IngredientItemWidget(
                          model: IngredientModel(
                            title: 'Ingredient$i',
                            useBy: i % 4 == 0
                                ? DateTime.now().subtract(Duration(days: 2))
                                : DateTime.now().add(Duration(days: 2)),
                          ),
                          lunchDate: DateTime.now(),
                          onSelected: (_) => setState(() {
                            if (_selectedIngredients.contains(i)) {
                              _selectedIngredients.remove(i);
                            } else {
                              _selectedIngredients.add(i);
                            }
                          }),
                          selected: _selectedIngredients.contains(i),
                        ),
                      );
                    },
                    itemCount: 10,
                  ),
                ),
                _getRecipesButton(),
              ],
            ),
          ),
        );
      },
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
                  arguments: ["Cheese", "Bread"],
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
