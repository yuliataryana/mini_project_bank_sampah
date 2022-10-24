import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mini_project_bank_sampah/model/account.dart';

class AuthViewmodel extends ChangeNotifier {
  AuthViewmodel._internal();
  static final _singleton = AuthViewmodel._internal();
  factory AuthViewmodel() => _singleton;

  Account? _loggedAccount;
  Account? _accountForm;

  Account? get loggedAccount => _loggedAccount;
  Account? get accountForm => _accountForm;

  void setLoggedAccount(Account? account) {
    _loggedAccount = account;
    notifyListeners();
  }

  void setAccountForm(Account? account) {
    _accountForm = account;
    notifyListeners();
  }

  Future<void> saveProfile() async {
    if (_loggedAccount == null) throw Exception("No logged account");
    await Hive.box<Account>('account').put(_loggedAccount!.uid, accountForm!);
    setLoggedAccount(accountForm);
    notifyListeners();
  }

  void logout() {
    _loggedAccount = null;
    notifyListeners();
  }

  bool get isLogged => _loggedAccount != null;

  bool get isNotLogged => !isLogged;

  Future<void> login(
      {required String username, required String password}) async {
    final box = Hive.box<Account>('account');
    final account = box.values.where(
      (element) =>
          (element.email == username || element.name == username) &&
          element.password == password,
    );

    if (account.isNotEmpty) {
      _loggedAccount = account.first;
      _accountForm = loggedAccount;
      notifyListeners();
    } else {
      throw Exception("Username or password is wrong");
    }
  }

  Future<void> register(
      {required String username,
      required String password,
      required String name}) async {
    final box = Hive.box<Account>('account');
    final account = box.values.where((element) => element.email == username);

    if (account.isNotEmpty) {
      throw Exception("Username already exist");
    } else {
      final newAccount = Account(
        uid: 1213,
        email: username,
        password: password,
        name: name,
        address: '',
        phone: '',
        photo: '',
      );
      final newUID = await box.add(newAccount);
      box.put(newUID, newAccount.copyWith(uid: newUID));
      // _loggedAccount = newAccount.copyWith(uid: newUID);
      notifyListeners();
    }
  }
}
