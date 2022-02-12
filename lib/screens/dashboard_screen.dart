import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:strata_wallet/components/custom_card.dart';
import 'package:strata_wallet/components/primary_button.dart';
import 'package:strata_wallet/components/transaction_item.dart';
import 'package:strata_wallet/constants.dart';
import 'package:strata_wallet/models/user.dart';
import 'package:strata_wallet/screens/transfer_strata_screen.dart';
import 'package:strata_wallet/screens/user_info_screen.dart';
import 'package:strata_wallet/screens/welcome_screen.dart';
import 'package:strata_wallet/utils/app_urls.dart';
import 'package:strata_wallet/utils/persistence.dart';
import 'package:strata_wallet/utils/user_provider.dart';

class DashboardScreen extends StatefulWidget {
  static String id = 'dashboard_screen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  User _user;
  int _selectedIndex = 0;
  String _strataBalance = '0.00';
  String _usdBalance = '0.00';

  Future<List<dynamic>> getUserRecords(User user) async {
    var result = [];

    String requestUrl = AppUrl.userRecordUrl + '${user?.walletAddress}';
    http.Response response = await http.get(
      Uri.parse(requestUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 1) {
        result = responseData['data']['logs'];
      }
    }

    return result;
  }

  Future getUserBalances(User user) async {
    var result = {};

    // User user = await UserPreferences().getUser();

    Uri requestUrl = Uri.parse(AppUrl.walletInfoUrl + '${user.walletAddress}');
    http.Response response = await http
        .get(requestUrl, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 1) {
        if (responseData['data']['address'] == user.walletAddress) {
          // if (this.mounted) {
          // setState(() {
          String strataBalance =
              responseData['data']['balance'].toStringAsFixed(4);
          String usdBalance = await convertStrataToUsd(strataBalance);

          result = {'strata': strataBalance, 'usd': usdBalance};
          // });
          // }
        }
      }
    }
    return result;
  }

  Future<String> convertStrataToUsd(String amount) async {
    String result = _usdBalance;
    String requestUrl = AppUrl.convertToUsdUrl + '$amount';

    http.Response response = await http.get(
      Uri.parse(requestUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      result = responseData['data'];
    }

    return result;
  }

  void onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Provider.of<UserProvider>(context, listen: false).setUser(User());
      UserPreferences().removeUser();
      Navigator.popAndPushNamed(context, WelcomeScreen.id);
    }
  }

  void loggedInUser() async {
    final User user = await UserPreferences().getUser();
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    loggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    User sessionUser = Provider.of<UserProvider>(context).user;
    User user = sessionUser.email != null ? sessionUser : _user;

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: kPrimaryColor,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 60.0,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          getUserRecords(user);
                        },
                        child: Icon(
                          Icons.refresh_outlined,
                          size: 35.0,
                          color: Colors.white,
                        ),
                      ),
                      flex: 0,
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: kPrimaryColor,
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0, bottom: 50.0),
                    child: FutureBuilder(
                      future: getUserBalances(user),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Text(
                                'Total Balance',
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 15.0,
                                  color: kTextMutedColor,
                                ),
                              ),
                              Text(
                                '\$${snapshot.data['usd']}',
                                style: kHeadingText1.copyWith(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                ),
                              ),
                              Text(
                                '${snapshot.data['strata']} STRLY',
                                style: kHeadingText4.copyWith(
                                  color: Color(0xffEDEDF4),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  CustomCard(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                    margin: EdgeInsets.only(
                      top: 140.0,
                      left: 20.0,
                      right: 20.0,
                      bottom: 10.0,
                    ),
                    decoration: kCustomCardDecoration.copyWith(
                      boxShadow: [kBoxShadowProp],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            PrimaryButton(
                              outlined: false,
                              child: Icon(Icons.arrow_downward),
                              width: 60.0,
                              circular: 15.0,
                              color: Color(0xffFF396F),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: UserInfoScreen(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text('Receive')
                          ],
                        ),
                        Column(
                          children: [
                            PrimaryButton(
                              outlined: false,
                              child: Icon(Icons.arrow_forward),
                              width: 60.0,
                              circular: 15.0,
                              color: kPrimaryColor,
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: TransferStrataScreen(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text('Transfer'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transactions',
                      style: kHeadingText2.copyWith(
                        fontSize: 25.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    StreamBuilder(
                      stream: Stream.periodic(
                        Duration(seconds: 5),
                      ).asyncMap((event) => getUserRecords(user)),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              return Text('Error ${snapshot.error}');
                            } else {
                              final List<dynamic> transactions = snapshot.data;
                              // print(snapshot.data.sublist(1, 5).length);
                              // return Text(transactions[0]['hash']);
                              return ListView.builder(
                                reverse: true,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final transaction = transactions[index];
                                  return TransactionItem(
                                      transaction, user.walletAddress);
                                },
                                itemCount: transactions.length,
                              );
                            }
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        iconSize: 30.0,
        onTap: onTap,
      ),
    );
  }
}
