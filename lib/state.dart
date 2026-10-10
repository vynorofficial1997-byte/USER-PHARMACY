import 'package:flutter/material.dart';
import 'models.dart';

/// Single in-memory store for the whole demo flow.
/// Swap the internals for API calls later; screens only talk to this class.
class AppState extends ChangeNotifier {
  final Map<String, int> _qty = {};
  Pharmacy? pharmacy;
  Coupon? coupon;
  PaymentMethod? paymentMethod;

  final List<Prescription> prescriptions = [
    Prescription('Prescription 1', 'Name of the Patient', DateTime(2026, 9, 28)),
    Prescription('Prescription 2', 'Name of the Patient', DateTime(2026, 9, 12)),
    Prescription('Prescription 3', 'Name of the Patient', DateTime(2026, 8, 30)),
    Prescription('Prescription 4', 'Name of the Patient', DateTime(2026, 8, 4)),
  ];

  List<Medicine> get catalog => kCatalog;
  List<Medicine> get purchaseAgain => kCatalog.take(6).toList();

  // ---- cart ----
  bool inCart(String id) => _qty.containsKey(id);
  int qty(String id) => _qty[id] ?? 0;
  int get itemCount => _qty.length;
  bool get cartEmpty => _qty.isEmpty;

  List<MapEntry<Medicine, int>> get lines => [
        for (final m in kCatalog)
          if (_qty.containsKey(m.id)) MapEntry(m, _qty[m.id]!)
      ];

  void toggle(Medicine m) {
    if (_qty.containsKey(m.id)) {
      _qty.remove(m.id);
    } else {
      _qty[m.id] = 1;
    }
    notifyListeners();
  }

  void setQty(Medicine m, int q) {
    if (q <= 0) {
      _qty.remove(m.id);
    } else {
      _qty[m.id] = q.clamp(1, 99).toInt();
    }
    notifyListeners();
  }

  void remove(Medicine m) {
    _qty.remove(m.id);
    notifyListeners();
  }

  // ---- order ----
  void selectPharmacy(Pharmacy p) {
    pharmacy = p;
    notifyListeners();
  }

  void applyCoupon(Coupon? c) {
    coupon = c;
    notifyListeners();
  }

  void selectPayment(PaymentMethod m) {
    paymentMethod = m;
    notifyListeners();
  }

  double get itemTotal =>
      lines.fold(0.0, (s, e) => s + e.key.price * e.value);

  double get discount {
    if (coupon == null) return 0;
    if (coupon!.code == 'AUSWAY10') return itemTotal * 0.10;
    if (coupon!.code == 'FIRST50') return itemTotal < 50 ? itemTotal : 50;
    return 0;
  }

  double get deliveryKm => pharmacy?.distanceKm ?? 0;
  double get deliveryFee => cartEmpty ? 0 : (20 + 8 * deliveryKm).roundToDouble();
  double get gst => (itemTotal - discount) * 0.025;
  double get sgst => (itemTotal - discount) * 0.025;
  double get total => itemTotal - discount + deliveryFee + gst + sgst;

  // ---- prescriptions ----
  void addPrescription(String patient) {
    prescriptions.insert(
      0,
      Prescription('Prescription ${prescriptions.length + 1}', patient, DateTime.now()),
    );
    notifyListeners();
  }

  /// Clears everything tied to the current order (after completion).
  void resetOrder() {
    _qty.clear();
    pharmacy = null;
    coupon = null;
    paymentMethod = null;
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  /// Use inside build() - rebuilds when state changes.
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  /// Use inside callbacks - no rebuild subscription.
  static AppState read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
