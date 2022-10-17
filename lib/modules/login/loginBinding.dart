import 'package:get/instance_manager.dart';

import 'loginController.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }

}
