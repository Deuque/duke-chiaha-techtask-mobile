import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tech_task/util/date_helper.dart';

import '../models/ingredient_model.dart';

class IngredientItemWidget extends StatelessWidget {
  final IngredientModel model;
  final DateTime lunchDate;
  final ValueChanged<IngredientModel> onSelected;
  final bool selected;

  const IngredientItemWidget({
    Key? key,
    required this.model,
    required this.lunchDate,
    required this.onSelected,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM, yyyy');
    final isSelectable = dmyDate(model.useBy) == dmyDate(lunchDate) ||
        dmyDate(model.useBy).isAfter(dmyDate(lunchDate));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: !isSelectable ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: !isSelectable
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
        onTap: () => onSelected(model),
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
        trailing: isSelectable ? _checkBox() : null,
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
        color: selected ? Colors.deepOrangeAccent : null,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: selected ? Colors.transparent : Colors.grey.withOpacity(.4),
          width: 2,
        ),
      ),
      child: selected
          ? SvgPicture.asset(
              'assets/images/check.svg',
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 20,
            )
          : const SizedBox.shrink(),
    );
  }
}
