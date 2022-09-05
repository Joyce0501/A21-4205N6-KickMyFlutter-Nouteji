//
// Future<SigninResponse> signup(SignupRequest req) async {
//   try {
//     var response = await Dio().post(
//         'https://kickmyb-server.herokuapp.com/api/id/signup',
//         data: req
//     );
//     print(response);
//     return  SigninResponse.fromJson(response.data);
//
//   } catch (e) {
//     print(e);
//     throw(e);
//   }
// }