
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:kick_my_flutter/transfer.dart';


class SingletonDio {

  static var cookiemanager = CookieManager(CookieJar());

  static Dio getDio() {
    Dio dio = Dio();
    dio.interceptors.add(cookiemanager);
    return dio;
  }
}

Future<SigninResponse> signup(SignupRequest req) async {
  try {
    var response = await SingletonDio.getDio().post(
        'http://10.0.2.2:8080/api/id/signup',
        data: req
    );
    print(response);
    return  SigninResponse.fromJson(response.data);
  }
  catch (e) {
    print(e);
    throw(e);
  }
}

Future<SigninResponse> signin(SigninRequest req) async {
  try {
    var response = await SingletonDio.getDio().post(
        'http://10.0.2.2:8080/api/id/signin',
        data: req
    );
    print(response);
    return  SigninResponse.fromJson(response.data);
  }
  catch (e) {
    print(e);
    throw(e);
  }
}

// Future addtask(AddTaskRequest task) async {
//   try {
//     var response = await SingletonDio.getDio().post(
//         'http://10.0.2.2:8080//api/add',
//         data: task
//     );
//     print(response);
//   }
//   catch (e) {
//     print(e);
//     throw(e);
//   }
// }