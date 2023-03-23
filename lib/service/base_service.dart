import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BaseService {
  SupabaseClient get supabaseClient => Supabase.instance.client;

  String get path;
}
