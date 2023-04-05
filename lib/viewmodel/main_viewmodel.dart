import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';
import 'package:mini_project_bank_sampah/model/bank_account.dart';
import 'package:mini_project_bank_sampah/model/cart_item.dart';
import 'package:mini_project_bank_sampah/model/detail_transaction.dart';
import 'package:mini_project_bank_sampah/model/transaction.dart';
import 'package:mini_project_bank_sampah/model/transfer_request.dart';
import 'package:mini_project_bank_sampah/model/waste_category.dart';
import 'package:mini_project_bank_sampah/service/transaction_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../service/waste_service.dart';

class MainViewmodel extends ChangeNotifier {
  MainViewmodel._internal();
  static final _singleton = MainViewmodel._internal();
  factory MainViewmodel() => _singleton;

  List<CartItem> _carts = [];
  List<CartItem> get carts => _carts;

  bool isAdmin = false;

  Future<void> saveCartToHivedb() async {
    final json = _carts.map((e) => e.toJson()).toList();
    final jsonString = await compute(jsonEncode, json);
    Hive.box<String>('cart').put('cart', jsonString);
  }

  Future<void> loadCartFromHivedb() async {
    final jsonString = Hive.box<String>('cart').get('cart');
    if (jsonString == null) {
      return;
    }
    final json =
        (await compute<String, dynamic>(jsonDecode, jsonString)) as List;
    _carts = json.map<CartItem>((e) => CartItem.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> clearCart() async {
    _carts = [];
    Hive.box<String>('cart').delete('cart');
    notifyListeners();
  }

  double get totalPrice {
    double total = _carts.isEmpty
        ? 0
        : _carts
            .map((element) =>
                //  element['price'] * element['qty']
                element.wastePrice * element.qty)
            .reduce((value, element) => value + element);
    return total;
  }

  List<WasteCategory> _itemsType = [];
  List<WasteCategory> get itemsType => _itemsType;

  void fetchWasteCategories() async {
    // if (_itemsType.isNotEmpty) {
    // return;
    // }
    _itemsType = await WasteService().getWasteCategories();
    notifyListeners();
  }

  void addItemToCart(WasteCategory newItem, double? qty) async {
    int index =
        _carts.indexWhere((item) => item.wasteName == newItem.wasteName);
    if (index == -1) {
      // newItem['qty'] = qty;
      _carts.add(
        CartItem(
          qty: qty ?? 0.0,
          idWaste: newItem.idWaste,
          createdAt: newItem.createdAt,
          wasteName: newItem.wasteName,
          wastePrice: newItem.wastePrice,
          imageUrl: newItem.imageUrl,
        ),
      );
    } else {
      _carts[index].qty += (qty ?? 0);
    }
    await saveCartToHivedb();
    notifyListeners();
  }

  void removeCartItem(CartItem item) async {
    _carts.removeWhere((element) => element.wasteName == item.wasteName);
    await saveCartToHivedb();
    notifyListeners();
  }

  Future<void> updateCartItem(CartItem item, qty) async {
    int index = _carts.indexWhere((element) => element.idWaste == item.idWaste);
    if (index == -1) {
      print(item.idWaste);
      print(_carts.map((e) => e.idWaste));

      return;
    }
    _carts[index].qty = qty;
    await saveCartToHivedb();
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> addOrUpdateWasteCategory(WasteCategory wasteCategory,
      {String? imagePath}) async {
    _isLoading = true;
    notifyListeners();
    print(wasteCategory.idWaste);
    if (wasteCategory.idWaste == null && imagePath != null) {
      final result =
          await WasteService().addWasteCategories(wasteCategory, imagePath);
      _isLoading = false;
      notifyListeners();
      return result;
    } else {
      final result = await WasteService().updateWasteCategories(wasteCategory);
      _isLoading = false;
      notifyListeners();
      return result;
    }
  }

  void deleteWasteItem(int? idWaste) async {
    if (_isLoading) {
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();
      await WasteService().deleteWasteCategory(idWaste);
      fetchWasteCategories();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Transaction> _transactions = [];
  List<Transaction> get transactions => isAdmin
      ? _transactions
          .where((element) => element.status == TransactionStatus.pending)
          .toList()
      : _transactions;

  int get balance {
    final trxs = _transactions
        .where((element) => element.status != TransactionStatus.pending)
        .map((element) {
      if (element.transactionType == TransactionType.income) {
        return element.subtotal;
      } else {
        return -element.subtotal;
      }
    }).toList();
    print(trxs.toString());
    print(trxs.length);
    return trxs.isEmpty ? 0 : trxs.reduce((value, element) => value + element);
  }

  void fetchTransactions(
    String userId,
  ) async {
    if (_transactions.isNotEmpty) {
      return;
    }

    _transactions =
        await TransactionService().getTransactions(userId, isAdmin: isAdmin);
    notifyListeners();
  }

  Future processSavingTransaction() async {
    if (_isLoading) {
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();
      final transactionDetails = _carts
          .map((e) => DetailIncomeTransaction(
                null,
                null,
                null,
                e.idWaste,
                e.qty,
              ))
          .toList();
      final newTransaction = Transaction(
        userid: "",
        status: TransactionStatus.pending,
        subtotal: totalPrice.toInt(),
        transactionType: TransactionType.income,
        detailTransaction: transactionDetails,
      );
      await TransactionService().addTransaction(newTransaction);
      _carts = [];
      await saveCartToHivedb();
      _transactions = await TransactionService().getTransactions(
          Supabase.instance.client.auth.currentUser!.id,
          isAdmin: isAdmin);
      print("fetch transaction");
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<BankAccount> _bankAccounts = [];
  List<BankAccount> get bankAccounts => _bankAccounts;

  void fetchBankAccounts() async {
    if (_bankAccounts.isNotEmpty) {
      return;
    }
    _bankAccounts =
        await TransactionService().getBankAccounts(isAdmin: isAdmin);
    notifyListeners();
  }

  Future<void> addBankAccount(BankAccount bankAccount) async {
    if (_isLoading) {
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();
      await TransactionService().addBankAccount(bankAccount);
      _bankAccounts = await TransactionService().getBankAccounts();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future processCashWidthdraw(int amount) async {
    if (_isLoading) {
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();
      final transactionDetails = [
        DetailOutcomeTransaction(
          null,
          null,
          null,
          {
            "method": "cash",
            "amount": amount,
          },
        ),
      ];
      final newTransaction = Transaction(
        userid: "",
        status: TransactionStatus.success,
        subtotal: amount,
        transactionType: TransactionType.outcome,
        detailTransaction: transactionDetails,
      );
      await TransactionService().addTransaction(newTransaction);
      _carts = [];
      await saveCartToHivedb();
      _transactions = await TransactionService().getTransactions(
          Supabase.instance.client.auth.currentUser!.id,
          isAdmin: isAdmin);
      print("fetch transaction");
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future processBankWidthdraw(TransferBankRequest request) async {
    if (_isLoading) {
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();
      List<DetailTransaction> transactionDetails = [];
      if (request.idBankAccount != null) {
        transactionDetails = [
          DetailOutcomeTransaction(
            null,
            null,
            null,
            {
              "method": "bank",
              "idBankAccount": request.idBankAccount,
              "amount": request.amount,
            },
          ),
        ];
      } else {
        if (request.isCreateNewBankAccount) {
          final newBankAccount = BankAccount(
            accountHolder: request.accountHolder!,
            accountNumber: request.accountNumber!,
            bankName: request.bankName!,
            userid: Supabase.instance.client.auth.currentUser!.id,
          );
          await TransactionService().addBankAccount(newBankAccount);
          _bankAccounts = await TransactionService().getBankAccounts();
          transactionDetails = [
            DetailOutcomeTransaction(
              null,
              null,
              null,
              {
                "method": "bank",
                "idBankAccount": _bankAccounts
                    .firstWhere((element) =>
                        element.accountNumber == request.accountNumber)
                    .idBankAccount,
                "amount": request.amount,
              },
            ),
          ];
        } else {
          transactionDetails = [
            DetailOutcomeTransaction(
              null,
              null,
              null,
              {
                "method": "bank",
                'bankName': request.bankName,
                'accountNumber': request.accountNumber,
                'accountHolder': request.accountHolder,
                "amount": request.amount,
              },
            ),
          ];
        }
      }

      final newTransaction = Transaction(
        status: TransactionStatus.success,
        userid: "",
        subtotal: request.amount,
        transactionType: TransactionType.outcome,
        detailTransaction: transactionDetails,
      );
      await TransactionService().addTransaction(newTransaction);
      _carts = [];
      await saveCartToHivedb();
      _transactions = await TransactionService().getTransactions(
          Supabase.instance.client.auth.currentUser!.id,
          isAdmin: isAdmin);
      print("fetch transaction");
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateTransaction(int? idTransaction, TransactionStatus status) async {
    if (_isLoading) {
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();
      await TransactionService().updateTransaction(idTransaction, status);
      _transactions = await TransactionService().getTransactions(
          Supabase.instance.client.auth.currentUser!.id,
          isAdmin: isAdmin);
      print("fetch transaction");
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
