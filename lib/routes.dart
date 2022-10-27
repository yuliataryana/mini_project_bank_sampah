import 'package:flutter/material.dart';
import 'package:mini_project_bank_sampah/view/screens/edit_profile_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/harga_sampah_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/home_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/login_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/onboarding_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/register_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/splash_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/tabungan_sampah_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/welcome_screen.dart';

class Routes {
  Route<dynamic>? call(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case '/splash':
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case '/price_list':
        return MaterialPageRoute(
            builder: (context) =>  HargaSampahScreen());
      case '/trash_bank':
        return MaterialPageRoute(
            builder: (context) => const TabunganSampahScreen());
      case '/onboarding':
        return MaterialPageRoute(
            builder: (context) => const OnboardingScreen());
      case '/welcome':
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case '/profile/edit':
        return MaterialPageRoute(
            builder: (context) => const EditProfileScreen());
      default:
        return MaterialPageRoute(builder: (context) => const Scaffold());
    }
  }
}
