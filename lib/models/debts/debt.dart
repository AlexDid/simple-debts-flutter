import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simpledebts/models/debts/operation.dart';
import 'package:simpledebts/models/user/user.dart';

part 'debt.g.dart';

enum DebtAccountType {
  SINGLE_USER,
  MULTIPLE_USERS
}

// TODO: connect user screens
enum DebtStatus {
  CREATION_AWAITING,
  UNCHANGED,
  CHANGE_AWAITING,
  USER_DELETED,
  CONNECT_USER
}

enum MoneyReceiveStatus {
  None,
  YouTake,
  YouGive
}

@JsonSerializable(explicitToJson: true)
class Debt {
  final String id;
  final User user;
  final DebtAccountType type;
  final String currency;
  final DebtStatus status;
  final String statusAcceptor;
  final double summary;
  final String moneyReceiver;
  final List<Operation> moneyOperations;

  Debt({
    @required this.id,
    @required this.user,
    @required this.type,
    @required this.currency,
    @required this.status,
    @required this.statusAcceptor,
    @required this.summary,
    @required this.moneyReceiver,
    @required this.moneyOperations
  });

  factory Debt.fromJson(Map<String, dynamic> json) => _$DebtFromJson(json);
  Map<String, dynamic> toJson() => _$DebtToJson(this);

  MoneyReceiveStatus get moneyReceiveStatus {
    return moneyReceiver == null
        ? MoneyReceiveStatus.None
        : moneyReceiver == user.id
          ? MoneyReceiveStatus.YouGive
          : MoneyReceiveStatus.YouTake;
  }

  Color getSummaryColor(BuildContext context) {
    Map<MoneyReceiveStatus, Color> moneyReceiveColors = {
      MoneyReceiveStatus.None: Theme.of(context).textTheme.headline6.color,
      MoneyReceiveStatus.YouTake: Theme.of(context).colorScheme.secondary,
      MoneyReceiveStatus.YouGive: Theme.of(context).colorScheme.primary,
    };

    return moneyReceiveColors[moneyReceiveStatus];
  }
}