import 'package:get/get.dart';

/// Las cinco secciones principales, en el mismo orden que la barra inferior de la web.
enum HomeTab { cosmos, discover, storm, community, galaxy }

class HomeController extends GetxController {
  final tab = HomeTab.discover.obs; // la web también abre en Discover

  void select(HomeTab next) => tab.value = next;
}
