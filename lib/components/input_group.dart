import 'package:flutter/material.dart';
import 'package:strata_wallet/constants.dart';

class InputGroup extends StatelessWidget {
  final String label;
  final bool obscureText;
  final String hintText;
  final void Function(String value) onChanged;

  const InputGroup(
      {@required this.label,
      this.hintText,
      this.obscureText,
      @required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextFormField(
            onChanged: onChanged,
            obscureText: obscureText,
            cursorColor: kPrimaryColor,
            validator: (value) =>
                value.isEmpty ? '$label cannot be empty' : null,
            decoration: InputDecoration(
              hintText: hintText ?? 'Your ${label.toLowerCase()}',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
