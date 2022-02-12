import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:strata_wallet/components/primary_button.dart';
import 'package:strata_wallet/constants.dart';
import 'package:strata_wallet/models/user.dart';
import 'package:strata_wallet/utils/user_provider.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  bool _clicked = false;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    return Container(
      padding: EdgeInsets.only(bottom: 30.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 20.0, left: 20.0, right: 20.0, bottom: 5.0),
            child: Text(
              'Receive Strata',
              style: kHeadingText2.copyWith(fontSize: 20.0),
            ),
          ),
          Divider(height: 20.0, thickness: 2),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                QrImage(
                  data: user.walletAddress,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                Text(
                  'Scan Qrcode or copy below address',
                  style: TextStyle(
                    color: kTextMutedColor,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${user.walletAddress.substring(1, 30)}...',
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: MaterialButton(
                          elevation: 5.0,
                          color: kPrimaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              _clicked = true;
                            });
                            Timer(Duration(seconds: 2), () {
                              setState(() {
                                _clicked = false;
                              });
                            });
                            Clipboard.setData(
                              ClipboardData(
                                text: user.walletAddress,
                              ),
                            );
                          },
                          child: _clicked ? Icon(Icons.check) : Text('copy'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryColor,
                      width: 0.3,
                    ),
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wallet'),
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
                SizedBox(
                  height: 20.0,
                ),
                PrimaryButton(
                  outlined: false,
                  child: Text('close'),
                  color: kPrimaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
