import 'package:flutter/material.dart';

void showProgress(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const Center(child: CircularProgressIndicator.adaptive());
    },
  );
}
