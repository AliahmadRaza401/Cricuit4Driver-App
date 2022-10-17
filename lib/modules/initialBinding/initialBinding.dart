import 'package:circuit4driver/modules/provider/provider.dart';
import 'package:get/instance_manager.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => provider(), fenix: true);
  }
}
