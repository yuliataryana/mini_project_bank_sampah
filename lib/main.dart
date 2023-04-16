import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mini_project_bank_sampah/common/utils.dart';
import 'package:mini_project_bank_sampah/routes.dart';
import 'package:mini_project_bank_sampah/supabase_config.dart';
import 'package:mini_project_bank_sampah/viewmodel/auth_viewmodel.dart';
import 'package:mini_project_bank_sampah/viewmodel/main_viewmodel.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.key,
  );
  await Hive.initFlutter();
  await Hive.openBox<String>('cart');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewmodel()),
        ChangeNotifierProvider(create: (_) => MainViewmodel()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          primarySwatch: createMaterialColor(
            hexToColor("#7A9D30"),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: Routes(),
        initialRoute: "/splash",
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
