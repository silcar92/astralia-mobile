import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../routes/app_routes.dart';
import '../../../services/session_service.dart';

/// Pantalla de inicio: recupera la sesión guardada y decide a dónde ir.
class SplashController extends GetxController {
  final _session = Get.find<SessionService>();

  /// Error de red al recuperar la sesión: se ofrece reintentar sin perder la sesión.
  final error = Rxn<ApiException>();

  @override
  void onReady() {
    super.onReady();
    start();
  }

  Future<void> start() async {
    error.value = null;
    try {
      Get.offAllNamed(routeFor(await _session.bootstrap()));
    } on ApiException catch (e) {
      error.value = e;
    }
  }

  static String routeFor(SessionStatus status) => switch (status) {
    SessionStatus.authenticated => AppRoutes.home,
    SessionStatus.needsOnboarding => AppRoutes.onboarding,
    _ => AppRoutes.login,
  };
}
