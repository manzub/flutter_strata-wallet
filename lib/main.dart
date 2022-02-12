import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strata_wallet/constants.dart';
import 'package:strata_wallet/models/user.dart';
import 'package:strata_wallet/screens/dashboard_screen.dart';
import 'package:strata_wallet/screens/login_screen.dart';
import 'package:strata_wallet/screens/registration_screen.dart';
import 'package:strata_wallet/screens/welcome_screen.dart';
import 'package:strata_wallet/utils/auth_provider.dart';
import 'package:strata_wallet/utils/persistence.dart';
import 'package:strata_wallet/utils/user_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MaterialApp(
        title: 'Strata.ly Wallet',
        theme: ThemeData(
          scaffoldBackgroundColor: kBodyColor,
          primaryColor: kPrimaryColor,
        ),
        home: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                } else if (snapshot.data.token == null) {
                  return WelcomeScreen();
                } else {
                  // UserPreferences().removeUser();
                  return DashboardScreen();
                }
            }
          },
        ),
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          DashboardScreen.id: (context) => DashboardScreen(),
        },
      ),
    );
  }
}
