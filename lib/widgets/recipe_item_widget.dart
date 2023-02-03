import 'package:flutter/material.dart';
import 'package:tech_task/models/recipe_model.dart';

class RecipeItemWidget extends StatelessWidget {
  final RecipeModel model;

  const RecipeItemWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.1),
            offset: Offset(0, 2),
            spreadRadius: 4,
            blurRadius: 12,
          )
        ],
      ),
      child: ExpansionTile(
        title: Text(model.title),
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 17.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: model.ingredients
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.ac_unit,
                              size: 13,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              e,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
