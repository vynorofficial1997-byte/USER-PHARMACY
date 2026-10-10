import 'package:flutter/material.dart';
import '../models.dart';
import '../routes.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _quickAdd(BuildContext context, AppState app, Medicine m) {
    final wasIn = app.inCart(m.id);
    app.toggle(m);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Text(wasIn ? '${m.name} removed from cart' : '${m.name} added to cart'),
      duration: const Duration(seconds: 2),
      action: wasIn
          ? null
          : SnackBarAction(label: 'VIEW CART', onPressed: () => Navigator.pushNamed(context, Routes.cart)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return AppFrame(
      child: Column(children: [
        const SizedBox(height: 10),
        SearchHeader(onSubmitted: (q) => Navigator.pushNamed(context, Routes.otc, arguments: q)),
        const SizedBox(height: 4),
        const PharmacyTitle(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 16),
            children: [
              _UploadCard(onTap: () => Navigator.pushNamed(context, Routes.prescriptions)),
              const SizedBox(height: 14),
              PanelCard(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(children: [
                  Text('PURCHASE AGAIN', style: AppText.heading(size: 12)),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: .95,
                    children: [
                      for (final m in app.purchaseAgain)
                        MedTile(label: m.name, selected: app.inCart(m.id), onTap: () => _quickAdd(context, app, m)),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _OtcBanner(onTap: () => Navigator.pushNamed(context, Routes.otc)),
                ]),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.15), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 84,
            child: Row(children: [
              const SizedBox(width: 90, child: Icon(Icons.edit_note_rounded, size: 56, color: Color(0xFFB7872B))),
              Container(width: 1, color: Colors.black12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('UPLOAD YOUR PRESCRIPTION', style: AppText.body(size: 12, w: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text("Upload your Doctor's Prescription to get the medicines",
                          style: AppText.body(size: 10, color: Colors.black54)),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _OtcBanner extends StatelessWidget {
  const _OtcBanner({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.maroon,
      borderRadius: BorderRadius.circular(6),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: SizedBox(
            width: double.infinity,
            child: Column(children: [
              Text('O T C', style: AppText.display(size: 54, spacing: 6)),
              const SizedBox(height: 4),
              Text('OVER THE COUNTER\nMEDICINES',
                  textAlign: TextAlign.center,
                  style: AppText.body(size: 15, w: FontWeight.w300, color: Colors.white70).copyWith(letterSpacing: 2.5, height: 1.3)),
            ]),
          ),
        ),
      ),
    );
  }
}
