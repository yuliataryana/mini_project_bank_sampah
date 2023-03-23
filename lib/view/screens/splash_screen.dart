import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';
import 'package:mini_project_bank_sampah/viewmodel/main_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _redirectCalled = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (_redirectCalled || !mounted) {
      return;
    }

    _redirectCalled = true;
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      context.read<MainViewmodel>().loadCartFromHivedb();
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 2), () {
    //   Navigator.pushReplacementNamed(context, "/onboarding");
    // });
    return Scaffold(
      backgroundColor: hexToColor('#F0F6DC'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo_sahaja.png",
              width: 200,
            ),
            const SizedBox(height: 20),
            Text(
              "Bank Sampah SAHAJA",
              textAlign: TextAlign.center,
              style: GoogleFonts.livvic(
                fontSize: 44,
                color: hexToColor("#7A9D30"),
              ),
              textScaleFactor: 1,
            ),
            const SizedBox(height: 10),
            Text(
              "Satu Sampah Satu Harapan",
              textAlign: TextAlign.center,
              style: GoogleFonts.livvic(
                color: hexToColor("#7A9D30"),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
