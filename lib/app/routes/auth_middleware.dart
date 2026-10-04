import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/session_service.dart';
import 'app_routes.dart';

/// Las pantallas internas no se abren sin sesión: si no hay, se va a entrar.
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final session = Get.find<SessionService>();
    return session.status.value == SessionStatus.guest
        ? const RouteSettings(name: AppRoutes.login)
        : null;
  }
}
