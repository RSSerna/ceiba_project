import 'package:intl/intl.dart' show NumberFormat;

String formatCurrency(double value) {
  final formatted = NumberFormat('#,##0', 'es_CO').format(value);
  return 'COP \$$formatted';
}

String formatFundName(String value) {
  return value
      .replaceAll('_', ' ')
      .replaceAll('-', ' ')
      .split(' ')
      .map((word) {
        if (word == 'FPV' || word == 'FIC' || word == 'BTG') return word;
        return word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1).toLowerCase();
      })
      .join(' ');
}
