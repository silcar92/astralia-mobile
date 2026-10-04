import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';

class ForgotPasswordController extends GetxController {
  final _auth = Get.find<AuthRepository>();

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final loading = false.obs;
  final sent = false.obs;
  final error = Rxn<Object>();

  Future<void> submit() async {
    if (loading.value || !(formKey.currentState?.validate() ?? false)) return;
    loading.value = true;
    error.value = null;
    try {
      await _auth.forgotPassword(email.text.trim());
      sent.value = true;
    } catch (e) {
      error.value = e;
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    email.dispose();
    super.onClose();
  }
}
