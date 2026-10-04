import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../services/session_service.dart';
import '../../splash/controllers/splash_controller.dart';

class RegisterController extends GetxController {
  final _session = Get.find<SessionService>();

  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final loading = false.obs;
  final error = Rxn<Object>();

  Future<void> submit() async {
    if (loading.value || !(formKey.currentState?.validate() ?? false)) return;
    loading.value = true;
    error.value = null;
    try {
      final status = await _session.register(
        name.text.trim(),
        email.text.trim(),
        password.text,
      );
      Get.offAllNamed(SplashController.routeFor(status));
    } catch (e) {
      error.value = e;
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
