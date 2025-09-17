import 'package:shared_preferences/shared_preferences.dart';

class LoginManager{    //key        value
  static const String _username = "username";
  static const String _password = "password";
  static const String _isLoggedIn = "isLoggedIn";

  //write user login credentials to shared preferences

   Future<bool> saveUserLoginData({required String username, required String password}) async {

    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      sharedPreferences.setString(_username, username);
      sharedPreferences.setString(_password, password);
      sharedPreferences.setBool(_isLoggedIn, true);
      return true;
    }catch(e){
      return false;
    }

  }

  //read user login credentials from shared preferences
   Future<Map<String, dynamic>> getUserLoginData() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? username = sharedPreferences.getString(_username);
    String? password = sharedPreferences.getString(_password);
    bool? isLoggedIn = sharedPreferences.getBool(_isLoggedIn);

    return{
      "username" : username,
      "password" : password,
      "isLoggedIn" : isLoggedIn,
      };
  }

  // check if it is logged in
  Future<bool> isLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(_isLoggedIn) ?? false;
 }

// check if it is logged out

  Future<void> isLoggedOut() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  await sharedPreferences.remove(_username);
  await sharedPreferences.remove(_password);
  await sharedPreferences.setBool(_isLoggedIn, false);
  sharedPreferences.clear();
 }
}