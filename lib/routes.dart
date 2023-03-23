import 'package:flutter/material.dart';
import 'package:mini_project_bank_sampah/view/admin/screens/add_or_edit_trash_item_screen.dart';
import 'package:mini_project_bank_sampah/view/admin/screens/customers_screen.dart';
import 'package:mini_project_bank_sampah/view/admin/screens/detail%20_customer.dart';
import 'package:mini_project_bank_sampah/view/screens/transaction/add_bank_account_screens.dart';
import 'package:mini_project_bank_sampah/view/screens/cart_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/edit_profile_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/harga_sampah_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/home_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/information_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/login_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/onboarding_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/register_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/splash_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/tabungan_sampah_screen.dart';
import 'package:mini_project_bank_sampah/view/admin/screens/tabung_sampah_screen.dart'
    as admin;
import 'package:mini_project_bank_sampah/view/screens/transaction/transaction_detail_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/transaction/transfer_bank_page.dart';
import 'package:mini_project_bank_sampah/view/screens/welcome_screen.dart';
import 'package:mini_project_bank_sampah/view/screens/transaction/widthdraw_screen.dart';
import 'package:mini_project_bank_sampah/viewmodel/auth_viewmodel.dart';
import 'package:mini_project_bank_sampah/viewmodel/main_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'model/transaction.dart';
import 'model/user_profile.dart';
import 'model/waste_category.dart';
import 'view/screens/transaction/balance_screen.dart';

class Routes {
  Route<dynamic>? call(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) {
          final userId = Supabase.instance.client.auth.currentSession?.user.id;
          if (userId != null) {
            Future.microtask(() {
              context.read<AuthViewmodel>().loadUserProfile(userId);
              context.read<MainViewmodel>().fetchTransactions(userId);
              context.read<MainViewmodel>().fetchBankAccounts();
              context.read<MainViewmodel>().fetchWasteCategories();
            });
          }
          return const HomeScreen();
        });
      case '/splash':
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      case "/widthdraw":
        return MaterialPageRoute(builder: (context) => const WidthDrawScreen());
      case "/widthdraw/bank-transfer":
        return MaterialPageRoute(
          builder: (context) => TransferBankPage(
            amount: settings.arguments as int,
          ),
        );
      case "/widthdraw/bank-transfer/new":
        return MaterialPageRoute(
          builder: (context) => AddBankAccount(
            amount: settings.arguments as int,
          ),
        );
      case "/transaction-detail":
        return MaterialPageRoute(
          builder: (context) => TransactionDetailScreen(
            transaction: settings.arguments as Transaction,
          ),
        );
      case '/price_list':
        return MaterialPageRoute(builder: (context) {
          context.read<MainViewmodel>().fetchWasteCategories();

          return const HargaSampahScreen();
        });
      case '/trash_bank':
        if (settings.arguments == "admin") {
          return MaterialPageRoute(
            builder: (context) {
              context.read<MainViewmodel>().fetchWasteCategories();
              return const admin.TabunganSampahScreen();
            },
          );
        }
        return MaterialPageRoute(
          builder: (context) {
            context.read<MainViewmodel>().fetchWasteCategories();
            return const TabunganSampahScreen();
          },
        );
      case '/onboarding':
        return MaterialPageRoute(
            builder: (context) => const OnboardingScreen());
      case '/welcome':
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());
      case '/information':
        return MaterialPageRoute(
            builder: (context) => const InformationScreen());
      case '/cart':
        return MaterialPageRoute(builder: (context) => const CartScreen());
      case '/form-waste':
        return MaterialPageRoute(
          builder: (context) => AddOrEditTrashItemScreen(
            wasteCategory: settings.arguments as WasteCategory?,
          ),
        );
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case '/profile/edit':
        return MaterialPageRoute(
            builder: (context) => EditProfileScreen(
                  userProfile: settings.arguments as UserProfile,
                ));
      case '/profile/balance':
        return MaterialPageRoute(
          builder: (context) => const BalanceScreen(),
        );
      case "/admin/customers":
        return MaterialPageRoute(builder: (context) => const CustomersScreen());
      case "/admin/customers/detail":
        return MaterialPageRoute(
          builder: (context) => DetailCustomer(
            userid: settings.arguments.toString(),
          ),
        );
      default:
        return MaterialPageRoute(builder: (context) => const Scaffold());
    }
  }
}
