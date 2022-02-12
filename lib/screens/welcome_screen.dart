import 'package:flutter/material.dart';
import 'package:strata_wallet/components/primary_button.dart';
import 'package:strata_wallet/constants.dart';
import 'package:strata_wallet/screens/login_screen.dart';
import 'package:strata_wallet/screens/registration_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static String id = 'welcome_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 150.0),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100.0),
                        child: Image.asset('assets/images/strataly-icon.png'),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Welcome to Strata.ly Wallet',
                        style: TextStyle(
                          color: kTextDarkColor,
                          fontSize: 25.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        'Your personal wallet app just for your strata coin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kTextMutedColor,
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                height: 84.0,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PrimaryButton(
                          color: kPrimaryColor,
                          outlined: true,
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, LoginScreen.id),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PrimaryButton(
                          outlined: false,
                          color: kPrimaryColor,
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          onPressed: () => Navigator.pushNamed(
                              context, RegistrationScreen.id),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
