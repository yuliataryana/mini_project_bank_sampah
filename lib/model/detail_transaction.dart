// ignore: unused_import
import 'dart:ffi';

import 'package:mini_project_bank_sampah/common/utils.dart';

abstract class DetailTransaction {
  // id_detail_income_transaction": 1,
  final int? idDetailTransaction;
  final int? idTransaction;
  // createAt
  final DateTime? createdAt;

  DetailTransaction(
      this.idDetailTransaction, this.idTransaction, this.createdAt);

  factory DetailTransaction.fromJson(Map<String, dynamic> json) {
    // print(json);
    if (!json.containsKey("method")) {
      // print("income: $json");
      return DetailIncomeTransaction.fromJson(json);
    } else {
      return DetailOutcomeTransaction.fromJson(json);
    }
  }

  DetailTransaction copyWith({
    int? idDetailTransaction,
    int? idTransaction,
    DateTime? createdAt,
  });

  Map<String, dynamic> toJson() => {
        "id_detail_transaction": idDetailTransaction,
        "id_transaction": idTransaction,
        "created_at": createdAt?.toIso8601String(),
      };
  //       "created_at": "2023-03-09T07:15:17.512905+00:00",
  //       "id_transaction": 1,
}

class DetailIncomeTransaction extends DetailTransaction {
  // "id_detail_income_transaction": 1,
  // "id_transaction": 1,
  // "created_at": "2023-03-09T07:15:17.512905+00:00",
  // "id_waste": 1,
  // "qty": 1,
  // "subtotal": 10000
  final int? idWaste;
  final double qty;

  DetailIncomeTransaction(
    int? idDetailTransaction,
    int? idTransaction,
    DateTime? createdAt,
    this.idWaste,
    this.qty,
  ) : super(idDetailTransaction, idTransaction, createdAt);

  factory DetailIncomeTransaction.fromJson(Map<String, dynamic> json) {
    return DetailIncomeTransaction(
      json['id_detail_income_transaction'],
      json['id_transaction'],
      DateTime.parse(json['created_at']),
      json['id_waste'],
      double.tryParse(json['waste_weight'].toString()) ?? 0,
    );
  }
  @override
  Map<String, dynamic> toJson() => {
        "id_detail_transaction": idDetailTransaction,
        "id_transaction": idTransaction,
        "created_at": createdAt?.toIso8601String(),
        "id_waste": idWaste,
        "waste_weight": qty,
      };

  @override
  DetailIncomeTransaction copyWith(
      {int? idDetailTransaction,
      int? idTransaction,
      DateTime? createdAt,
      int? idWaste,
      double? qty}) {
    return DetailIncomeTransaction(
      idDetailTransaction ?? this.idDetailTransaction,
      idTransaction ?? this.idTransaction,
      createdAt ?? this.createdAt,
      idWaste ?? this.idWaste,
      qty ?? this.qty,
    );
  }
}

class DetailOutcomeTransaction extends DetailTransaction {
  // "id_detail_outcome_transaction": 1,
  // "id_transaction": 1,
  // "created_at": "2023-03-09T07:15:17.512905+00:00",
  // "id_waste": 1,
  // "qty": 1,
  // "subtotal": 10000
  final method;

  DetailOutcomeTransaction(
    int? idDetailTransaction,
    int? idTransaction,
    DateTime? createdAt,
    this.method,
  ) : super(idDetailTransaction, idTransaction, createdAt);

  factory DetailOutcomeTransaction.fromJson(Map<String, dynamic> json) {
    return DetailOutcomeTransaction(
      json['id_detail_outcome_transaction'],
      json['id_transaction'],
      DateTime.parse(json['created_at']),
      json['method'],
    );
  }
  @override
  Map<String, dynamic> toJson() => {
        "id_detail_transaction": idDetailTransaction,
        "id_transaction": idTransaction,
        "created_at": createdAt?.toIso8601String(),
        "method": method,
      };

  @override
  DetailOutcomeTransaction copyWith(
      {int? idDetailTransaction,
      int? idTransaction,
      DateTime? createdAt,
      dynamic method}) {
    return DetailOutcomeTransaction(
      idDetailTransaction ?? this.idDetailTransaction,
      idTransaction ?? this.idTransaction,
      createdAt ?? this.createdAt,
      method ?? this.method,
    );
  }
}
