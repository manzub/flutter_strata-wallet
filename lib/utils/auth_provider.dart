import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strata_wallet/models/user.dart';

import 'app_urls.dart';
import 'persistence.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String email, password) async {
    var result = {'status': false, 'message': 'An error occurred'};

    //construct request object
    final Map<String, dynamic> requestBody = {
      'email': email,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    // fetch user token and verify login details
    http.Response response = await http.post(
      Uri.parse(AppUrl.loginUrl),
      body: jsonEncode(requestBody),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 200) {
        // save user token and wallet address
        var token = responseData['token'];
        var walletAddress = responseData['wallet'];

        // fetch user info/login details
        http.Response response2 = await http.get(
          Uri.parse(AppUrl.userInfoUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response2.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response2.body);

          if (responseData['status'] == 'active') {
            // save response data
            var userData = responseData;
            userData['token'] = token;

            // create new user object
            User authUser = User.fromJson(userData);

            // save user to local
            UserPreferences().saveUser(authUser);

            // change login status
            _loggedInStatus = Status.LoggedIn;
            notifyListeners();

            result = {
              'status': true,
              'message': 'successful',
              'user': authUser
            };
          } else
            loginError(responseData);
        }
      } else {
        loginError(responseData);
      }
    }

    return result;
  }

  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    var result = {'status': false, 'message': 'An error occurred'};

    final Map<String, dynamic> requestBody = {
      'name': username,
      'email': email,
      'password': password,
    };

    _registeredInStatus = Status.Registering;
    notifyListeners();

    http.Response response = await http.post(
      Uri.parse(AppUrl.registerUrl),
      body: jsonEncode(requestBody),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      _registeredInStatus = Status.Registered;
      notifyListeners();

      print(responseData['status']);
      if (responseData['status'] == 200) {
        final data = await login(email, password);
        result = data;
      } else {
        _registeredInStatus = Status.NotRegistered;
        notifyListeners();
      }
    }

    return result;
  }

  Map<String, dynamic> loginError(Map<String, dynamic> responseData) {
    _loggedInStatus = Status.NotLoggedIn;
    notifyListeners();
    return {
      'status': false,
      'message': responseData['message'] ?? 'An error occurred'
    };
  }
}
