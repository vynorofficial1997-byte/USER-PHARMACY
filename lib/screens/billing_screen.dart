import 'package:flutter/material.dart';
import '../models.dart';
import '../routes.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  void _pickCoupon(BuildContext context) {
    final app = AppScope.read(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.panel,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Padding(padding: EdgeInsets.all(16), child: Text('Apply a coupon', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
          for (final c in kCoupons)
            ListTile(
              leading: const Icon(Icons.local_offer_outlined, color: AppColors.maroon),
              title: Text(c.code, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(c.description),
              trailing: app.coupon?.code == c.code ? const Icon(Icons.check_circle, color: AppColors.maroon) : null,
              onTap: () {
                app.applyCoupon(c);
                Navigator.pop(context);
              },
            ),
          if (app.coupon != null)
            TextButton(
              onPressed: () {
                app.applyCoupon(null);
                Navigator.pop(context);
              },
              child: const Text('Remove coupon'),
            ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final lines = app.lines;

    return AppFrame(
      child: Stack(children: [
        Column(children: [
          const SizedBox(height: 10),
          const SearchHeader(),
          const SizedBox(height: 4),
          const PharmacyTitle(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: PanelCard(
                child: lines.isEmpty
                    ? const Placeholder404(text: 'Nothing to bill.')
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(10, 14, 10, 100),
                        children: [
                          for (final e in lines) ...[
                            _ItemRow(medicine: e.key, qty: e.value),
                            const SizedBox(height: 12),
                          ],
                          _OrderSummary(app: app),
                          const SizedBox(height: 14),
                          InkWell(
                            onTap: () => _pickCoupon(context),
                            child: Container(
                              height: 76,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: AppColors.rose, borderRadius: BorderRadius.circular(8)),
                              child: app.coupon == null
                                  ? Text('COUPONS', style: AppText.heading(size: 26, color: Colors.black26))
                                  : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Text(app.coupon!.code, style: AppText.heading(size: 20, color: AppColors.maroon)),
                                      Text('Applied · tap to change', style: AppText.body(size: 11, color: Colors.black54)),
                                    ]),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: AppColors.rose, borderRadius: BorderRadius.circular(12)),
                            child: Row(children: [
                              const Icon(Icons.location_on_outlined, color: AppColors.maroon),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('Delivery address', style: AppText.body(size: 13, w: FontWeight.w800)),
                                  Text('Home · tap to change', style: AppText.body(size: 11, color: Colors.black54)),
                                ]),
                              ),
                            ]),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ]),
        Positioned(
          left: 10,
          right: 10,
          bottom: 12,
          child: SlideActionButton(
            label: 'PAY NOW',
            sublabel: rupee(app.total),
            onTap: () => Navigator.pushNamed(context, Routes.payment),
          ),
        ),
      ]),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.medicine, required this.qty});
  final Medicine medicine;
  final int qty;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.read(context);
    return Container(
      height: 76,
      decoration: BoxDecoration(color: AppColors.rose, borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        const SizedBox(width: 78, child: Icon(Icons.medication_liquid_rounded, size: 42, color: Color(0xFFE08A3C))),
        Container(width: 1, height: 60, color: Colors.black12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(medicine.name.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.body(size: 12, w: FontWeight.w800)),
              Text(medicine.strength, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.body(size: 10, color: Colors.black54)),
            ]),
          ),
        ),
        _Stepper(qty: qty, onChanged: (q) => app.setQty(medicine, q)),
        SizedBox(
          width: 64,
          child: Text(rupee(medicine.price * qty),
              textAlign: TextAlign.center, style: AppText.body(size: 12, w: FontWeight.w800)),
        ),
      ]),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.qty, required this.onChanged});
  final int qty;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) {
    Widget btn(IconData i, VoidCallback f) =>
        InkWell(onTap: f, child: SizedBox(width: 24, height: 24, child: Icon(i, size: 14)));
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 3, offset: const Offset(0, 1))],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        btn(Icons.remove, () => onChanged(qty - 1)),
        SizedBox(width: 28, child: Text(qty.toString().padLeft(2, '0'), textAlign: TextAlign.center, style: AppText.body(size: 11, color: Colors.black54))),
        btn(Icons.add, () => onChanged(qty + 1)),
      ]),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.app});
  final AppState app;

  @override
  Widget build(BuildContext context) {
    TextStyle h = AppText.body(size: 11, color: Colors.black54, w: FontWeight.w500);
    TextStyle c = AppText.body(size: 11);
    Widget kv(String k, String v, {bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(children: [
            Expanded(child: Text(k, style: bold ? c.copyWith(fontWeight: FontWeight.w800) : c)),
            Text(v, style: bold ? c.copyWith(fontWeight: FontWeight.w800) : c),
          ]),
        );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.panel, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('ORDER SUMMARY', style: AppText.body(size: 14, w: FontWeight.w700, color: Colors.black54)),
        const SizedBox(height: 10),
        Row(children: [
          SizedBox(width: 36, child: Text('S. No.', style: h)),
          Expanded(child: Text('Item', style: h)),
          SizedBox(width: 60, child: Text('Quantity', textAlign: TextAlign.center, style: h)),
          SizedBox(width: 68, child: Text('Price(₹)', textAlign: TextAlign.right, style: h)),
        ]),
        const SizedBox(height: 6),
        for (var i = 0; i < app.lines.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(children: [
              SizedBox(width: 36, child: Text('${i + 1}', style: c)),
              Expanded(child: Text(app.lines[i].key.name, style: c, overflow: TextOverflow.ellipsis)),
              SizedBox(width: 60, child: Text('${app.lines[i].value}', textAlign: TextAlign.center, style: c)),
              SizedBox(
                  width: 68,
                  child: Text(rupee(app.lines[i].key.price * app.lines[i].value), textAlign: TextAlign.right, style: c)),
            ]),
          ),
        const Divider(height: 24),
        kv('Item Total', rupee(app.itemTotal)),
        if (app.discount > 0) kv('Coupon (${app.coupon!.code})', '- ${rupee(app.discount)}'),
        kv('Delivery Fee (${app.deliveryKm} kms)', rupee(app.deliveryFee)),
        kv('GST & Other Charges', rupee(app.gst + app.sgst)),
        const SizedBox(height: 4),
        kv('TOTAL', rupee(app.total), bold: true),
      ]),
    );
  }
}
