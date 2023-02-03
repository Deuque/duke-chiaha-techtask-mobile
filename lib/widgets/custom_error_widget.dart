import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final VoidCallback onRefresh;
  final String message;

  const CustomErrorWidget({
    Key? key,
    required this.onRefresh,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: onRefresh,
          child: Text('Retry'),
        )
      ],
    );
  }
}
