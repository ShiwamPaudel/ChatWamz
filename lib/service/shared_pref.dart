import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{
  static String userIdKey = 'USERKEY';
  static String userNameKey = 'USERNAMEKEY';
  static String userEmailKey = 'USEREMAILKEY';
  static String userPicKey = 'USERPICKEY';
  static String displayNameKey = 'USERDISPLAYNAME';

  Future<bool> saveUserId(String getUserId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserPic(String getUserPic) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPicKey, getUserPic);
  }

  Future<bool> saveUserDisplayName(String getUserDisplayName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(displayNameKey, getUserDisplayName);
  }

  /// Get
  
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserPic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPicKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayNameKey);
  }

}