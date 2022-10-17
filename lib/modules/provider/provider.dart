import 'package:get/get.dart';

class provider extends GetConnect {
  Future<Response> login(Map data) => post(
    'loginEndPoint',
    data,
    contentType: 'application/json',
  ).timeout(const Duration(seconds: 20));

  @override
  void onInit() {
    httpClient.baseUrl = 'appbaseUrl';
    httpClient.maxAuthRetries = 3;
    super.onInit();
  }


}
