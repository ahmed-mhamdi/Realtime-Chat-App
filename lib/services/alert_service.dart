import 'package:chat_app_material3/services/navigation_service.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AlertService {
  AlertService() {}
  void showAlert({
    required String content,
    IconData icon = Icons.info,
    String title = "Alert",
  }) {
    try {
      DelightToastBar(
        autoDismiss: true,
        position: DelightSnackbarPosition.top,
        snackbarDuration: const Duration(seconds: 3),
        builder: (context) => ToastCard(
          title: Text(title),
          subtitle: Text(content),
          leading: Icon(
            icon,
            size: 28,
          ),
        ),
      ).show(GetIt.instance
          .get<NavigationService>()
          .navigatorKey!
          .currentContext!);
    } catch (e) {}
  }
}
