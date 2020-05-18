import 'package:flutter/cupertino.dart';
import 'package:simpledebts/mixins/api_service_with_auth_headers.dart';
import 'package:simpledebts/models/common/currency.dart';

class CurrencyProvider extends ApiServiceWithAuthHeaders with ChangeNotifier {
  
  List<Currency> _currencies = [];
  
  List<Currency> get currencies {
    return [..._currencies];
  }

  List<String> get setOfCurrencyIso {
    return currencies.map((currency) => currency.currency)
        .where((currency) => currency.isNotEmpty)
        .toSet()
        .toList();
  }
  
  Future<void> fetchAndSetCurrencies() async {
    if(_currencies.length == 0) {
      final url = '/common/currency';
      final response = await http().get(url);
      final List currencies = response.data;
      _currencies = currencies
          .map((currency) => Currency.fromJson(currency))
          .toList();
      notifyListeners();
    }
  }

  Currency getCurrencyByIso(String currencyIso) {
    return _currencies.firstWhere((currency) => currency.currency == currencyIso);
  }

}