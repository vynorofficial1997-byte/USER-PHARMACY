import 'package:flutter/material.dart';
import 'routes.dart';
import 'screens/home_screen.dart';
import 'screens/otc_screen.dart';
import 'screens/prescriptions_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/choose_pharmacy_screen.dart';
import 'screens/order_status_screen.dart';
import 'screens/billing_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/coming_soon_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings s) {
  final name = s.name ?? Routes.home;
  Widget page;

  if (name.startsWith('${Routes.tab}/')) {
    page = ComingSoonScreen(index: int.tryParse(name.split('/').last) ?? 1);
  } else {
    switch (name) {
      case Routes.otc:
        page = OtcScreen(initialQuery: (s.arguments as String?) ?? '');
        break;
      case Routes.prescriptions:
        page = const PrescriptionsScreen();
        break;
      case Routes.cart:
        page = const CartScreen();
        break;
      case Routes.choosePharmacy:
        page = const ChoosePharmacyScreen();
        break;
      case Routes.awaitBill:
        page = const OrderStatusScreen(stage: OrderStage.awaitingBill);
        break;
      case Routes.billing:
        page = const BillingScreen();
        break;
      case Routes.payment:
        page = const PaymentScreen();
        break;
      case Routes.awaitAccept:
        page = const OrderStatusScreen(stage: OrderStage.awaitingAcceptance);
        break;
      case Routes.home:
      default:
        page = const HomeScreen();
    }
  }
  return MaterialPageRoute(settings: s, builder: (_) => page);
}
