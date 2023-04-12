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
import 'package:mini_project_bank_sampah/model/user_profile.dart';

enum TransactionType { income, outcome }

enum TransactionStatus { pending, success, failed }

extension TransactionStatusExt on TransactionStatus {
  String get name {
    switch (this) {
      case TransactionStatus.pending:
        return "pending";
      case TransactionStatus.success:
        return "success";
      case TransactionStatus.failed:
        return "failed";
      default:
        return "pending";
    }
  }

  TransactionStatus fromString(String name) {
    switch (name) {
      case "pending":
        return TransactionStatus.pending;
      case "success":
        return TransactionStatus.success;
      case "failed":
        return TransactionStatus.failed;
      default:
        return TransactionStatus.pending;
    }
  }
}

class Transaction {
  Transaction({
    this.idTransaction,
    this.createdAt,
    required this.userid,
    required this.status,
    required this.subtotal,
    required this.transactionType,
    required this.detailTransaction,
  });

  int? idTransaction;
  DateTime? createdAt;
  String userid;
  int subtotal;
  TransactionStatus status;
  TransactionType transactionType;
  List<DetailTransaction> detailTransaction;
  UserProfile? userProfile;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        idTransaction: json["id_transaction"],
        status: TransactionStatus.pending.fromString(json["status"]),
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
        "status": status.name,
        "transaction_type":
            transactionType == TransactionType.income ? "income" : "outcome",
      };
}
