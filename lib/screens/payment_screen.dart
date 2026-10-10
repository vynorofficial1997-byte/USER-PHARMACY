import 'package:flutter/material.dart';
import '../models.dart';
import '../routes.dart';
import '../state.dart';
import '../theme.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _upi = TextEditingController();
  final _card = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();

  @override
  void dispose() {
    _upi.dispose();
    _card.dispose();
    _expiry.dispose();
    _cvv.dispose();
    super.dispose();
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _pay(AppState app) async {
    final method = app.paymentMethod;
    if (method == null) return _snack('Choose a payment method');
    if (method == PaymentMethod.upi && !_upi.text.contains('@')) return _snack('Enter a valid UPI ID');
    if (method == PaymentMethod.card) {
      final digits = _card.text.replaceAll(RegExp(r'\D'), '');
      if (digits.length != 16 || _expiry.text.trim().length < 4 || _cvv.text.trim().length < 3) {
        return _snack('Enter valid card details');
      }
    }

    // TODO(backend): call payment gateway here.
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.maroon)),
    );
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    Navigator.of(context).pop(); // close progress dialog
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.awaitAccept, (r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.rose,
      body: Column(children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, top + 20, 20, 22),
          color: AppColors.maroon,
          child: Stack(alignment: Alignment.center, children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white, size: 30)),
            ),
            Text('PAYMENT',
                style: AppText.heading(size: 30, color: Colors.white).copyWith(shadows: const [Shadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3))])),
          ]),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            color: AppColors.panel,
            child: ListView(padding: const EdgeInsets.fromLTRB(8, 40, 8, 24), children: [
              _SummaryCard(app: app),
              const SizedBox(height: 40),
              _Methods(
                app: app,
                upi: _upi,
                card: _card,
                expiry: _expiry,
                cvv: _cvv,
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 54,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: AppColors.maroon,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                  onPressed: () => _pay(app),
                  child: Text('PAY ${rupee(app.total)}', style: AppText.body(size: 16, w: FontWeight.w800, color: Colors.white)),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.app});
  final AppState app;
  @override
  Widget build(BuildContext context) {
    Widget row(String k, String v, {double size = 14, Color? color}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(children: [
            Expanded(child: Text(k, style: AppText.body(size: size, color: color ?? Colors.black54))),
            Text(v, style: AppText.body(size: size, color: color ?? Colors.black54)),
          ]),
        );

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(children: [
        row('Medicine', rupee(app.itemTotal), size: 22, color: Colors.black87),
        const Divider(height: 24),
        if (app.discount > 0) row('Discount (${app.coupon!.code})', '- ${rupee(app.discount)}'),
        row('Delivery Charges', rupee(app.deliveryFee)),
        row('GST', rupee(app.gst)),
        row('SGST', rupee(app.sgst)),
        const Divider(height: 24),
        row('Total Amount', rupee(app.total), size: 22, color: Colors.black87),
      ]),
    );
  }
}

class _Methods extends StatelessWidget {
  const _Methods({required this.app, required this.upi, required this.card, required this.expiry, required this.cvv});
  final AppState app;
  final TextEditingController upi, card, expiry, cvv;

  @override
  Widget build(BuildContext context) {
    Widget option(PaymentMethod m, String title, String sub, IconData icon) {
      final sel = app.paymentMethod == m;
      return GestureDetector(
        onTap: () => app.selectPayment(m),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: sel ? Border.all(color: AppColors.maroon, width: 1.5) : null,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.25), blurRadius: 5, offset: const Offset(0, 3))],
          ),
          child: Row(children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(shape: BoxShape.circle, color: sel ? AppColors.maroon : const Color(0xFFDDDDDD)),
              child: sel ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text.rich(TextSpan(children: [
                TextSpan(text: title, style: AppText.body(size: 14, w: FontWeight.w600)),
                TextSpan(text: ' $sub', style: AppText.body(size: 13, color: Colors.black54)),
              ])),
            ),
            Icon(icon, size: 22),
          ]),
        ),
      );
    }

    InputDecoration dec(String hint) => InputDecoration(
          hintText: hint,
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        );

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(.6), borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Choose payment Method', style: AppText.body(size: 14, w: FontWeight.w600, color: Colors.black54)),
        const SizedBox(height: 16),
        option(PaymentMethod.upi, 'UPI', '(Gpay/Phonepe/Paytm)', Icons.qr_code_2_rounded),
        if (app.paymentMethod == PaymentMethod.upi)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: TextField(controller: upi, keyboardType: TextInputType.emailAddress, decoration: dec('UPI ID (e.g. name@okaxis)')),
          ),
        option(PaymentMethod.card, 'CARD', '(Debit/Credit)', Icons.credit_card_rounded),
        if (app.paymentMethod == PaymentMethod.card)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(children: [
              TextField(controller: card, keyboardType: TextInputType.number, maxLength: 19, decoration: dec('Card number').copyWith(counterText: '')),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: TextField(controller: expiry, keyboardType: TextInputType.datetime, decoration: dec('MM/YY'))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: cvv, keyboardType: TextInputType.number, obscureText: true, maxLength: 4, decoration: dec('CVV').copyWith(counterText: ''))),
              ]),
            ]),
          ),
      ]),
    );
  }
}
