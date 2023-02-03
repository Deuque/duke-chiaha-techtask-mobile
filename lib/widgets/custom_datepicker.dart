import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatefulWidget {
  final String label;
  final DateTime? initialDate, firstDate, lastDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateFormat dateFormat;

  const CustomDateField({
    Key? key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.label,
    required this.dateFormat,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  bool _datePickerExpanded = false;
  DateTime? _selectedDate;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _onDateSelected(widget.initialDate);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _datePickerExpanded = false;
        setState(() {});
      }
    });
  }

  void _onDateSelected(DateTime? dateTime) {
    _selectedDate = dateTime;
    String text = '';
    if (dateTime != null) {
      text = widget.dateFormat.format(dateTime);
      widget.onDateSelected(dateTime);
    }
    _controller.text = text;
    setState(() {});
  }

  void _onTapFormField() async {
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
    _datePickerExpanded = !_datePickerExpanded;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withOpacity(.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            readOnly: true,
            onTap: _onTapFormField,
            focusNode: _focusNode,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: widget.label,
                border: InputBorder.none,
                suffix: RotatedBox(
                  quarterTurns: _datePickerExpanded ? 3 : 1,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.grey[600],
                  ),
                )),
            controller: _controller,
          ),
          AnimatedSize(
            curve: Curves.decelerate,
            duration: const Duration(milliseconds: 400),
            child: _datePickerExpanded
                ? Column(
                    children: [
                      const Divider(
                        height: 1,
                      ),
                      SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: CupertinoDatePicker(
                          minimumDate: widget.firstDate,
                          maximumDate: widget.lastDate,
                          initialDateTime: _selectedDate ??
                              widget.initialDate ??
                              widget.lastDate
                                  ?.subtract(const Duration(days: 1)),
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: _onDateSelected,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
