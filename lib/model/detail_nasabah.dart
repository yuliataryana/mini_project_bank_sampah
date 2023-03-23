import 'package:mini_project_bank_sampah/model/transaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'user_profile.dart';

class DetailNasabah {
  User user;
  UserProfile userProfile;
  List<Transaction> transaction;
  DetailNasabah({
    required this.user,
    required this.userProfile,
    required this.transaction,
  });
}
