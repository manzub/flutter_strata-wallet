import 'package:flutter/material.dart';

enum TransactionType { Received, Transfered }

const kBodyColor = Color(0xffededf4);

const kTextDarkColor = Color(0xff27173E);

const kTextMutedColor = Color(0xff958d9e);

const kPrimaryColor = Color(0xff6236FF);

const kHeadingText1 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 40.0,
  fontWeight: FontWeight.w700,
);

const kHeadingText2 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 30.0,
  fontWeight: FontWeight.w700,
);

const kHeadingText4 = TextStyle(
  color: kTextDarkColor,
  fontFamily: 'Poppins',
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
);

const kCustomCardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(
    Radius.circular(10.0),
  ),
);

BoxShadow kBoxShadowProp = BoxShadow(
  color: Colors.grey.withOpacity(0.5),
  offset: Offset(1, 2),
);

Widget kFormLoading = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    CircularProgressIndicator(),
    Text('Loading... Please wait'),
  ],
);
