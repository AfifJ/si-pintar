import 'dart:convert';
import 'package:si_pintar/constant/api_constants.dart';
import 'package:http/http.dart' as http;

Future<String> convertCurrency(
    String amount, String sourceCurrency, String targetCurrency) async {
  sourceCurrency = sourceCurrency.toLowerCase();
  targetCurrency = targetCurrency.toLowerCase();

  final response = await http.get(
    Uri.parse('${ApiConstants.currencyApiBaseUrl}/${sourceCurrency}.json'),
  );
  final data = jsonDecode(response.body);
  double result = double.parse(
      (data[sourceCurrency][targetCurrency] * double.parse(amount))
          .toStringAsFixed(2));

  return result.toString();
}
