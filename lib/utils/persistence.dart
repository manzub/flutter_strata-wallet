import 'package:shared_preferences/shared_preferences.dart';
import 'package:strata_wallet/models/user.dart';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    bool committed = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // save User data;
    await prefs.setInt('id', user.id);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('walletAddress', user.walletAddress);
    await prefs.setString('profile_photo_url', user.profilePhotoUrl);
    await prefs.setString('token', user.token);
    committed = true;

    return committed;
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.getInt('id');
    String name = prefs.getString('name');
    String email = prefs.getString('email');
    String walletAddress = prefs.getString('walletAddress');
    String profilePhotoUrl = prefs.getString('profile_photo_url');
    String token = prefs.getString('token');

    return User(
      id: id,
      name: name,
      email: email,
      walletAddress: walletAddress,
      profilePhotoUrl: profilePhotoUrl,
      token: token,
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('id');
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('walletAddress');
    prefs.remove('profile_photo_url');
    prefs.remove('token');
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = (prefs.getString('token') ?? '');
    return token;
  }
}
