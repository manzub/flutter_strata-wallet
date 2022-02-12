import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:strata_wallet/components/custom_card.dart';
import 'package:strata_wallet/components/input_group.dart';
import 'package:strata_wallet/components/primary_button.dart';
import 'package:strata_wallet/constants.dart';
import 'package:strata_wallet/models/user.dart';
import 'package:strata_wallet/utils/auth_provider.dart';
import 'package:strata_wallet/utils/user_provider.dart';

import 'dashboard_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    void processLogin() async {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();

        final Map<String, dynamic> loginResponse =
            await auth.login(_email, _password);

        if (loginResponse['status']) {
          User user = loginResponse['user'];
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          print('login successful');
          await Navigator.pushNamed(context, DashboardScreen.id);
        } else {
          print('login failed');
          final snackBar = SnackBar(content: Text(loginResponse['message']));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: auth.loggedInStatus == Status.Authenticating,
          child: Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Log In',
                                style: kHeadingText1,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Center(
                              child: Text(
                                'Fill the form to Log In',
                                style: kHeadingText4,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            CustomCard(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    InputGroup(
                                      label: 'E-mail',
                                      obscureText: false,
                                      onChanged: (newEmail) {
                                        _email = newEmail;
                                      },
                                    ),
                                    InputGroup(
                                      label: 'Password',
                                      obscureText: true,
                                      onChanged: (newPassword) {
                                        _password = newPassword;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              decoration: kCustomCardDecoration.copyWith(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    offset: Offset(1, 2),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, RegistrationScreen.id),
                              child: Text(
                                'Register Now',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 60.0,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: PrimaryButton(
                    color: kPrimaryColor,
                    outlined: false,
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: processLogin,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
