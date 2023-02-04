import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../models/ingredient_model.dart';

class IngredientItemWidget extends StatelessWidget {
  final IngredientModel model;
  final ValueChanged<IngredientModel> onSelected;
  final bool hasExpired;
  final bool isSelected;

  const IngredientItemWidget({
    Key? key,
    required this.model,
    required this.onSelected,
    required this.hasExpired,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM, yyyy');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: hasExpired ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: hasExpired
            ? null
            : [
                BoxShadow(
                    color: Colors.grey.withOpacity(.1),
                    offset: Offset(0, 2),
                    spreadRadius: 4,
                    blurRadius: 12)
              ],
      ),
      child: ListTile(
        onTap: hasExpired ? null : () => onSelected(model),
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SvgPicture.asset(
            'assets/images/receipt.svg',
            height: 18,
          ),
        ),
        shape: RoundedRectangleBorder(),
        horizontalTitleGap: 0,
        title: Text(model.title),
        subtitle: Text(dateFormat.format(model.useBy)),
        trailing: hasExpired ?  null : _checkBox(),
      ),
    );
  }

  Widget _checkBox() {
    return AnimatedContainer(
      height: 20,
      width: 20,
      curve: Curves.decelerate,
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isSelected ? Colors.deepOrangeAccent : null,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey.withOpacity(.4),
          width: 2,
        ),
      ),
      child: isSelected
          ? SvgPicture.asset(
              'assets/images/check.svg',
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 20,
            )
          : const SizedBox.shrink(),
    );
  }
}
