import 'package:flutter/material.dart';
import '../routes.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

class OtcScreen extends StatefulWidget {
  const OtcScreen({super.key, this.initialQuery = ''});
  final String initialQuery;
  @override
  State<OtcScreen> createState() => _OtcScreenState();
}

class _OtcScreenState extends State<OtcScreen> {
  late String _query = widget.initialQuery;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final q = _query.trim().toLowerCase();
    final items = app.catalog.where((m) => q.isEmpty || m.name.toLowerCase().contains(q)).toList();

    return AppFrame(
      child: Stack(children: [
        Column(children: [
          const SizedBox(height: 10),
          SearchHeader(initialText: widget.initialQuery, onChanged: (v) => setState(() => _query = v)),
          const SizedBox(height: 4),
          const PharmacyTitle(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: PanelCard(
                child: items.isEmpty
                    ? const Placeholder404(text: 'No medicines found')
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: .95,
                        ),
                        itemCount: items.length,
                        itemBuilder: (_, i) {
                          final m = items[i];
                          return MedTile(
                            label: m.name,
                            caption: m.strength,
                            selected: app.inCart(m.id),
                            onTap: () => app.toggle(m),
                          );
                        },
                      ),
              ),
            ),
          ),
        ]),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedSlide(
            offset: app.itemCount > 0 ? Offset.zero : const Offset(0, 1.2),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: _SelectionBar(count: app.itemCount, onViewCart: () => Navigator.pushNamed(context, Routes.cart)),
          ),
        ),
      ]),
    );
  }
}

class _SelectionBar extends StatelessWidget {
  const _SelectionBar({required this.count, required this.onViewCart});
  final int count;
  final VoidCallback onViewCart;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
      decoration: const BoxDecoration(
        color: Color(0xFFE5A8A8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(children: [
        Expanded(
          child: Text('$count MEDICINE(S)\nSELECTED',
              style: AppText.body(size: 15, w: FontWeight.w800, color: Colors.white).copyWith(height: 1.3)),
        ),
        Material(
          color: AppColors.maroon,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            onTap: onViewCart,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('VIEW\nCART', textAlign: TextAlign.center, style: AppText.body(size: 12, w: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 2),
                const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
