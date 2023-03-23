import 'package:mini_project_bank_sampah/model/detail_nasabah.dart';
import 'package:mini_project_bank_sampah/model/short_profile.dart';
import 'package:mini_project_bank_sampah/service/auth_service.dart';
import 'package:mini_project_bank_sampah/service/base_service.dart';
import 'package:mini_project_bank_sampah/supabase_config.dart';
import 'package:supabase/supabase.dart';

import 'transaction_service.dart';

class AdminService extends BaseService {
  @override
  String get path => "user_profile";

  Future<List<ShortProfile>> getShortProfiles() async {
    try {
      final response =
          await supabaseClient.from(path).select().eq("role", "nasabah");
      return (response as List).map((e) => ShortProfile.fromJson(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<DetailNasabah> getDetailNasabah(String userid) async {
    try {
      final userRes = await supabaseClient.auth.admin.getUserById(userid);
      // final userRes = SupabaseClient(SupabaseConfig.url, supabaseKey)
      print("get profile by id: $userid");
      final profile = await AuthService().getProfile(userid);
      print("profile: $profile");
      print("get transaction by id: $userid");
      final transaction = await TransactionService().getTransactions(userid);
      return DetailNasabah(
        user: userRes.user!,
        userProfile: profile,
        transaction: transaction,
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
