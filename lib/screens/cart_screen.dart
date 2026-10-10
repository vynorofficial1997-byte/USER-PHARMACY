import 'package:flutter/material.dart';
import '../routes.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Stack(alignment: Alignment.center, children: [
                      Text('CART', style: AppText.heading(size: 17)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                          color: AppColors.maroon,
                          borderRadius: BorderRadius.circular(4),
                          child: InkWell(
                            onTap: () => Navigator.of(context).popUntil((r) => r.settings.name == Routes.otc || r.isFirst),
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                              child: Text('Add', style: AppText.body(size: 14, color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: lines.isEmpty
                        ? const Placeholder404(text: 'Your cart is empty.\nTap "Add" to pick medicines.')
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: .95,
                            ),
                            itemCount: lines.length,
                            itemBuilder: (_, i) {
                              final m = lines[i].key;
                              return MedTile(label: m.name, caption: m.strength, onRemove: () => app.remove(m));
                            },
                          ),
                  ),
                ]),
              ),
            ),
          ),
        ]),
        Positioned(
          left: 10,
          right: 10,
          bottom: 12,
          child: SlideActionButton(
            label: 'CHECK PHARMACY\nAVAILABILITY',
            onTap: () {
              if (app.cartEmpty) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Add at least one medicine first')));
                return;
              }
              Navigator.pushNamed(context, Routes.choosePharmacy);
            },
          ),
        ),
      ]),
    );
  }
}
