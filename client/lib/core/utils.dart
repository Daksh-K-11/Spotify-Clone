import 'package:client/core/widgets/animated_snackbar_content.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content, bool isSuccess) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        content: AnimatedSnackBarContent(
          message: content,
          isSuccess: isSuccess,
        ),
      ),
    );
}
