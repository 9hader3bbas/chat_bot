import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/my_services/my_services.dart';

class AppMiddileWare extends GetMiddleware {
  @override
  int? get priority => 1;
  MyServices myServices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    return null;
  }
}
