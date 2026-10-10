import 'dart:async';
import 'package:flutter/material.dart';
import '../routes.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

enum OrderStage { awaitingBill, awaitingAcceptance }

/// Covers both "medicen booking" designs:
///  - awaitingBill        -> "PLEASE WAIT For Pharmacy Bill"  (+ CANCEL ORDER)
///  - awaitingAcceptance  -> "PLEASE WAIT Until the Pharmacy ACCEPTS"
/// Both auto-advance after [kDemoDelay] to simulate the pharmacy responding.
class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key, required this.stage});
  final OrderStage stage;
  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  Timer? _timer;
  bool _accepted = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(kDemoDelay, _advance);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _advance() {
    if (!mounted) return;
    if (widget.stage == OrderStage.awaitingBill) {
      Navigator.pushReplacementNamed(context, Routes.billing);
    } else {
      setState(() => _accepted = true);
    }
  }

  Future<void> _cancel() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel order?'),
        content: const Text('Your cart will be kept so you can choose another pharmacy.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes, cancel')),
        ],
      ),
    );
    if (ok == true && mounted) {
      _timer?.cancel();
      Navigator.of(context).popUntil((r) => r.settings.name == Routes.cart || r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBill = widget.stage == OrderStage.awaitingBill;

    return AppFrame(
      showNav: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
        child: Column(children: [
          Text('ORDER STATUS', style: AppText.body(size: 20, w: FontWeight.w400, color: const Color(0xFF5A0F0F))),
          Expanded(
            child: Center(
              child: _accepted
                  ? Column(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.check_circle_rounded, size: 72, color: AppColors.maroon),
                      const SizedBox(height: 16),
                      Text('ORDER ACCEPTED', style: AppText.heading(size: 22, color: Colors.black)),
                      const SizedBox(height: 8),
                      Text('The pharmacy is preparing your medicines.',
                          textAlign: TextAlign.center, style: AppText.body(size: 14, color: Colors.black54)),
                    ])
                  : Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('PLEASE WAIT', style: AppText.body(size: 20, w: FontWeight.w300, color: Colors.black)),
                      const SizedBox(height: 4),
                      Text(isBill ? 'For Pharmacy\nBill' : 'Until the Pharmacy\nACCEPTS',
                          textAlign: TextAlign.center,
                          style: AppText.heading(size: 20, color: Colors.black).copyWith(height: 1.2)),
                      const SizedBox(height: 28),
                      const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.maroon),
                      ),
                    ]),
            ),
          ),
          if (_accepted)
            _PillButton(
              label: 'BACK TO PHARMACY',
              onTap: () {
                AppScope.read(context).resetOrder();
                Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (_) => false);
              },
            )
          else if (isBill)
            _PillButton(label: 'CANCEL ORDER', onTap: _cancel)
          else
            const SizedBox(height: 52),
        ]),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.35), blurRadius: 6, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: AppColors.rose,
        shape: const StadiumBorder(side: BorderSide(color: AppColors.maroon, width: 2)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Center(child: Text(label, style: AppText.body(size: 15, w: FontWeight.w500, color: Colors.black))),
        ),
      ),
    );
  }
}
