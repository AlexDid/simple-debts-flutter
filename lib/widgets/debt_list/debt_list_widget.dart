import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/store/currency.store.dart';
import 'package:simpledebts/store/debt_list.store.dart';
import 'package:simpledebts/widgets/common/empty_list_placeholder.dart';
import 'package:simpledebts/widgets/debt_list/debt_list_item.dart';

class DebtListWidget extends StatefulWidget {
  @override
  _DebtListWidgetState createState() => _DebtListWidgetState();
}

class _DebtListWidgetState extends State<DebtListWidget> {
  final DebtListStore _debtListStore = GetIt.instance<DebtListStore>();

  final CurrencyStore _currencyStore = GetIt.instance<CurrencyStore>();

  Stream<List<Debt>> _debts$;

  Future<void> _refreshDebtsList() async {
    await _currencyStore.fetchCurrencies();
    return _debtListStore.fetchAndSetDebtList();
  }

  Stream<List<Debt>> get _debtsStream => Stream.fromFuture(_refreshDebtsList()).flatMap((_) => _debtListStore.debts$);

  @override
  Widget build(BuildContext context) {
    if(_debts$ == null) {
      _debts$ = _debtsStream;
    }

    return StreamBuilder(
      stream: _debts$,
      builder: (context, snapshot) {
        if(snapshot.error != null) {
          print(snapshot.error);
          return Center(
            child: Text('Something went wrong. Try again later'),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final debts = snapshot.data;

          if(debts.length == 0) {
            return EmptyListPlaceholder(
              icon: Icons.assistant,
              title: 'There are no items yet',
              subtitle: 'press \'+\' to add the first debt',
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => _refreshDebtsList(),
              child: ListView.builder(
                  itemCount: debts.length,
                  itemBuilder: (context, index) => DebtListItem(debts[index])
              ),
            );
          }
        }
      },
    );
  }
}