import 'package:driven_site_locator/config/sl_routes.dart';
import 'package:get/get.dart';

SlNavTo slNavTo = SlNavTo();

class SlNavTo {
  Future<T?>? searchPlace<T>({dynamic arguments}) async {
    return Get.toNamed(SLRoutes.searchPlace, arguments: arguments);
  }
}
