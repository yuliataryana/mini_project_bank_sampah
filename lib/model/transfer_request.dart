class TransferBankRequest {
  final int? idBankAccount;
  final String? bankName;
  final String? accountNumber;
  final String? accountHolder;
  final int amount;
  final bool isCreateNewBankAccount;
  factory TransferBankRequest.instantTransfer({
    required int amount,
    required String bankName,
    required String accountNumber,
    required String accountHolder,
  }) {
    return TransferBankRequest(
      amount: amount,
      bankName: bankName,
      accountNumber: accountNumber,
      accountHolder: accountHolder,
    );
  }

  factory TransferBankRequest.fromBankAccount(
      {required int amount, required int? idBankAccount}) {
    return TransferBankRequest(
      amount: amount,
      idBankAccount: idBankAccount,
    );
  }
  factory TransferBankRequest.fromNewBankAccount({
    required int amount,
    required String bankName,
    required String accountNumber,
    required String accountHolder,
  }) {
    return TransferBankRequest(
      amount: amount,
      bankName: bankName,
      accountNumber: accountNumber,
      accountHolder: accountHolder,
      isCreateNewBankAccount: true,
    );
  }

  TransferBankRequest({
    this.idBankAccount,
    this.bankName,
    this.accountNumber,
    this.accountHolder,
    required this.amount,
    this.isCreateNewBankAccount = false,
  });
}
