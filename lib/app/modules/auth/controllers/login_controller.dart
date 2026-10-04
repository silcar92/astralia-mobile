import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../services/session_service.dart';
import '../../splash/controllers/splash_controller.dart';

class LoginController extends GetxController {
  final _session = Get.find<SessionService>();

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final loading = false.obs;

  /// El error crudo: la vista lo traduce con el idioma actual.
  final error = Rxn<Object>();

  Future<void> submit() async {
    if (loading.value || !(formKey.currentState?.validate() ?? false)) return;
    loading.value = true;
    error.value = null;
    try {
      final status = await _session.login(email.text.trim(), password.text);
      Get.offAllNamed(SplashController.routeFor(status));
    } catch (e) {
      error.value = e;
    } finally {
      loading.value = false;
    }
  }

  void goToRegister() => Get.toNamed(AppRoutes.register);
  void goToForgot() => Get.toNamed(AppRoutes.forgotPassword);

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
