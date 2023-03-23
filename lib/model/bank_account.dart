// [
//     {
//         "id_bank_account": 1,
//         "created_at": "2023-03-10T01:07:00.895606+00:00",
//         "bank_name": "BCA",
//         "account_number": "123456789012",
//         "account_holder": "umu",
//         "userid": "dbf56420-7fe2-4a14-880c-06991df38066"
//     }
// ]

class BankAccount {
  BankAccount({
    this.idBankAccount,
    this.createdAt,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
    required this.userid,
  });

  int? idBankAccount;
  DateTime? createdAt;
  String bankName;
  String accountNumber;
  String accountHolder;
  String userid;

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        idBankAccount: json["id_bank_account"],
        createdAt: DateTime.parse(json["created_at"]),
        bankName: json["bank_name"],
        accountNumber: json["account_number"],
        accountHolder: json["account_holder"],
        userid: json["userid"],
      );

  Map<String, dynamic> toJson() => {
        "id_bank_account": idBankAccount,
        "created_at": createdAt?.toIso8601String(),
        "bank_name": bankName,
        "account_number": accountNumber,
        "account_holder": accountHolder,
        "userid": userid,
      };
}
