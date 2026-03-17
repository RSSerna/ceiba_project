import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final text = newValue.text.replaceAll('.', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final remaining = text.length - i;
      if (remaining % 3 == 0 && i != 0) {
        buffer.write('.');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
