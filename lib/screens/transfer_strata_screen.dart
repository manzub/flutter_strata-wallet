import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:strata_wallet/components/input_group.dart';
import 'package:strata_wallet/components/primary_button.dart';
import 'package:strata_wallet/constants.dart';
import 'package:strata_wallet/models/user.dart';
import 'package:strata_wallet/utils/app_urls.dart';
import 'package:strata_wallet/utils/user_provider.dart';

enum TransactionStatus { Processing, Completed }

class TransferStrataScreen extends StatefulWidget {
  @override
  _TransferStrataScreenState createState() => _TransferStrataScreenState();
}

class _TransferStrataScreenState extends State<TransferStrataScreen> {
  final _formKey = GlobalKey<FormState>();

  String _gas = '0.00';
  String _receiverWallet = '';
  String _amount;
  String _message = '';
  TransactionStatus _status;

  void calculateGasFees() async {
    String requestUrl = AppUrl.calcGasFeesUrl + '$_amount';
    http.Response response = await http.get(
      Uri.parse(requestUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      setState(() {
        _gas = responseData['data'].toString();
      });
    }
  }

  Future<bool> verifyWalletAddress() async {
    bool result = false;
    Uri requestUrl = Uri.parse(AppUrl.walletInfoUrl + '$_receiverWallet');
    http.Response response = await http
        .get(requestUrl, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 1) {
        if (responseData['data']['address'] == _receiverWallet) {
          result = true;
        }
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    void processTransaction() async {
      String message = 'An Error Occurred';
      // ea6e21ec8de177dfa5e74b5ec49eaab0396da0a37ce0aa7e3efd5e35a9643029

      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();

        setState(() {
          _status = TransactionStatus.Processing;
        });

        if (_receiverWallet != user.walletAddress) {
          final isValidEmail = await verifyWalletAddress();

          if (isValidEmail) {
            print('processing transaction');
            String requestUrl = AppUrl.transferStrataUrl +
                '${user.walletAddress}/$_receiverWallet/$_amount';

            http.Response response = await http.get(
              Uri.parse(requestUrl),
              headers: {
                'Content-Type': 'application/json',
              },
            );

            if (response.statusCode == 200) {
              final Map<String, dynamic> responseData =
                  jsonDecode(response.body);

              if (responseData['status'] == 1) {
                if (responseData['data']['id'] != null) {
                  message = 'Transaction Successful';
                  Navigator.pop(context);

                  final snackBar = SnackBar(content: Text(message));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            }
          } else {
            message = 'Invalid Receiver Address';
          }
        } else {
          message = 'Invalid Receiver Address';
        }
        setState(() {
          _message = message;
          _status = TransactionStatus.Completed;
        });
      }
    }

    return Container(
      padding: EdgeInsets.only(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 20.0, left: 20.0, right: 20.0, bottom: 5.0),
            child: Text(
              'Send Strata',
              style: kHeadingText2.copyWith(fontSize: 20.0),
            ),
          ),
          Divider(height: 20.0, thickness: 2),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    margin: EdgeInsets.only(bottom: 20.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffc0bfbf),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('From'),
                        Text(
                          'STRLY (${user?.walletAddress?.substring(1, 20)}...)',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InputGroup(
                    label: 'To',
                    hintText: 'Enter Wallet Address',
                    obscureText: false,
                    onChanged: (value) {
                      _receiverWallet = value;
                    },
                  ),
                  Container(
                    // width: double.infinity,
                    padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Enter Amount'),
                        Row(
                          children: [
                            Text(
                              'STRLY',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (value) => value.isEmpty
                                    ? 'Field cannot be empty'
                                    : null,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                onChanged: (value) {
                                  _amount = value;
                                  // TODO: calculate gas fee;
                                  calculateGasFees();
                                },
                                cursorColor: kPrimaryColor,
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                                decoration: InputDecoration(
                                  hintText: '0',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'Gas Fee:',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: kTextMutedColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$_gas',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    _message,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  _status == TransactionStatus.Processing
                      ? CircularProgressIndicator()
                      : PrimaryButton(
                          outlined: false,
                          child: Text('Send'),
                          color: kPrimaryColor,
                          onPressed: processTransaction,
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
