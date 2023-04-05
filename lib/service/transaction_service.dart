import 'package:mini_project_bank_sampah/model/bank_account.dart';

import '../model/detail_transaction.dart';
import '../model/transaction.dart';
import 'base_service.dart';

class TransactionService extends BaseService {
  TransactionService._internal();
  static final _singleton = TransactionService._internal();
  factory TransactionService() => _singleton;

  @override
  String get path => "transaction";

  Future<List<Transaction>> getTransactions(String userId,
      {required bool isAdmin}) async {
    try {
      // final response = await supabaseClient.from(path).select();
      final responses = await Future.wait([
        isAdmin
            ? supabaseClient.from(path).select()
            : supabaseClient.from(path).select().eq("userid", userId),
        supabaseClient.from('detail_income_transaction').select(),
        supabaseClient.from('detail_outcome_transaction').select(),
      ]);

      print(responses);

      final transactions =
          (responses[0] as List).map((e) => Transaction.fromJson(e)).toList();
      final detailIncomeTransactions = (responses[1] as List).map(
        (json) {
          return DetailTransaction.fromJson(json);

          // final data = DetailTransaction.fromJson(e);
        },
      ).toList();
      final detailOutcomeTransactions = (responses[2] as List)
          .map(
            (e) => DetailTransaction.fromJson(e),
          )
          .toList();
      // print(detailIncomeTransactions);
      return transactions.map((e) {
        if (e.transactionType == TransactionType.income) {
          e.detailTransaction = detailIncomeTransactions
              .where((element) => element.idTransaction == e.idTransaction)
              .toList();
        } else {
          e.detailTransaction = detailOutcomeTransactions
              .where((element) => element.idTransaction == e.idTransaction)
              .toList();
        }
        return e;
      }).toList();
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      final response = await supabaseClient.from(path).insert([
        {
          "userid": supabaseClient.auth.currentUser!.id,
          "subtotal": transaction.subtotal,
          "transaction_type":
              transaction.transactionType == TransactionType.income
                  ? "income"
                  : "outcome",
        }
      ]).select();
      if (response.length > 0) {
        final idTransaction = response[0]["id_transaction"];
        if (transaction.transactionType == TransactionType.income) {
          final detailIncomeTransactions = transaction.detailTransaction
              .map(
                (e) => e.copyWith(idTransaction: idTransaction).toJson()
                  ..removeWhere(
                    (key, value) => value == null,
                  ),
              )
              .toList();
          await supabaseClient
              .from('detail_income_transaction')
              .insert(detailIncomeTransactions);
        } else {
          final detailOutcomeTransactions = transaction.detailTransaction
              .map((e) => e.copyWith(idTransaction: idTransaction).toJson()
                ..removeWhere(
                  (key, value) => value == null,
                ))
              .toList();
          await supabaseClient
              .from('detail_outcome_transaction')
              .insert(detailOutcomeTransactions);
        }
      } else {
        throw Exception("Failed to add transaction");
      }
      return response;
    } catch (e) {
      print(e);
    }
  }

  Future<List<BankAccount>> getBankAccounts({bool isAdmin = false}) async {
    try {
      if (isAdmin) {
        final response = await supabaseClient.from('bank_account').select();
        return (response as List).map((e) => BankAccount.fromJson(e)).toList();
      }
      final response = await supabaseClient
          .from('bank_account')
          .select()
          .eq("userid", supabaseClient.auth.currentUser!.id);
      return (response as List).map((e) => BankAccount.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<void> addBankAccount(BankAccount bankAccount) async {
    try {
      final response = await supabaseClient.from('bank_account').insert([
        {
          "bank_name": bankAccount.bankName,
          "account_number": bankAccount.accountNumber,
          "account_holder": bankAccount.accountHolder,
          "userid": supabaseClient.auth.currentUser!.id
        }
      ]).select();
      return response;
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateTransaction(
      int? idTransaction, TransactionStatus status) async {
    try {
      final response = await supabaseClient.from(path).update(
        {
          "status": status.name,
        },
      ).eq("id_transaction", idTransaction);
      return response;
    } catch (e) {
      print(e);
    }
  }
}
