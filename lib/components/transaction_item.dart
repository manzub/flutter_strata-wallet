import 'package:flutter/material.dart';
import 'package:strata_wallet/constants.dart';

import 'custom_card.dart';

class TransactionItem extends StatelessWidget {
  final transaction;
  final String walletAddress;

  const TransactionItem(this.transaction, this.walletAddress);

  bool isSender() {
    return transaction['from'] == walletAddress;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: kCustomCardDecoration.copyWith(
        boxShadow: [kBoxShadowProp],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            isSender() ? Icons.arrow_forward : Icons.arrow_downward,
            size: 40.0,
            color: isSender() ? kPrimaryColor : Colors.green,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isSender() ? 'Transferred Strata' : 'Received Strata',
                style: kHeadingText2.copyWith(fontSize: 17.0),
              ),
              Text(
                  '${isSender() ? 'To' : 'From'}: ${isSender() ? transaction['to'].substring(1, 15) : transaction['from'].substring(1, 15)}....')
            ],
          ),
          Text(
              '${isSender() ? '-' : '+'} ${transaction['value'] > 100 ? '>= 100' : transaction['value'].toStringAsFixed(2)} STRLY'),
        ],
      ),
    );
  }
}
