import 'package:flutter/material.dart';

class AppDialogs {
  static void showCustomMessageDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Закрыть'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  static void showErrorMessageDialog({
    required BuildContext context,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ошибка!'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Закрыть'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  static void showConfirmationDialog({
    required BuildContext context,
    required String message,
    required Function onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Необходимо подтверждение'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Отмена'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Подтвердить'),
            onPressed: () {
              onConfirm();
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
