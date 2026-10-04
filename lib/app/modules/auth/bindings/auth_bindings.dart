import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/register_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(LoginController.new);
}

class RegisterBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(RegisterController.new);
}

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(ForgotPasswordController.new);
}
