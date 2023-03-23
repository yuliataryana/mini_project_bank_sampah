// [
//     {
//         "id_transaction": 1,
//         "created_at": "2023-03-09T07:07:37.873541+00:00",
//         "userid": "dbf56420-7fe2-4a14-880c-06991df38066",
//         "subtotal": 250000,
//         "transaction_type": "income"
//     }
// ]

import 'package:mini_project_bank_sampah/model/detail_transaction.dart';

enum TransactionType { income, outcome }

class Transaction {
  Transaction({
    this.idTransaction,
    this.createdAt,
    required this.userid,
    required this.subtotal,
    required this.transactionType,
    required this.detailTransaction,
  });

  int? idTransaction;
  DateTime? createdAt;
  String userid;
  int subtotal;
  TransactionType transactionType;
  List<DetailTransaction> detailTransaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        idTransaction: json["id_transaction"],
        detailTransaction: [],
        createdAt: DateTime.parse(json["created_at"]),
        userid: json["userid"],
        subtotal: json["subtotal"],
        transactionType: json["transaction_type"] == "income"
            ? TransactionType.income
            : TransactionType.outcome,
      );

  Map<String, dynamic> toJson() => {
        "id_transaction": idTransaction,
        "created_at": createdAt?.toIso8601String(),
        "userid": userid,
        "subtotal": subtotal,
        "transaction_type":
            transactionType == TransactionType.income ? "income" : "outcome",
      };
}
