import 'package:flutter/material.dart';
import '../routes.dart';
import '../state.dart';
import '../theme.dart';
import '../models.dart';
import '../widgets.dart';

class ChoosePharmacyScreen extends StatelessWidget {
  const ChoosePharmacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final selected = app.pharmacy;

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
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('CHOOSE PHARMACY', style: AppText.heading(size: 17)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: .95,
                      children: [
                        for (final p in kPharmacies)
                          MedTile(
                            label: p.name,
                            caption: '${p.distanceKm} km',
                            selected: selected?.id == p.id,
                            onTap: () => app.selectPharmacy(p),
                          ),
                      ],
                    ),
                  ),
                  if (selected != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: AppColors.rose, borderRadius: BorderRadius.circular(10)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(selected.name, style: AppText.body(size: 14, w: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('${selected.distanceKm} km away · ${selected.note}',
                              style: AppText.body(size: 12, color: Colors.black54)),
                        ]),
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
            label: 'BILL',
            onTap: () {
              if (app.pharmacy == null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Please choose a pharmacy')));
                return;
              }
              Navigator.pushNamed(context, Routes.awaitBill);
            },
          ),
        ),
      ]),
    );
  }
}
