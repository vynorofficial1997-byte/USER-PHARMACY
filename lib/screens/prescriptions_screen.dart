import 'package:flutter/material.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
String _fmt(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  Future<void> _upload(BuildContext context) async {
    // TODO(backend/native): replace with image_picker (camera / gallery) + upload.
    final source = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.panel,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined, color: AppColors.maroon),
            title: const Text('Take a photo'),
            onTap: () => Navigator.pop(context, 'camera'),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined, color: AppColors.maroon),
            title: const Text('Choose from gallery'),
            onTap: () => Navigator.pop(context, 'gallery'),
          ),
        ]),
      ),
    );
    if (source == null || !context.mounted) return;

    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Patient name'),
        content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(hintText: 'Name of the patient')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Upload')),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty || !context.mounted) return;
    AppScope.read(context).addPrescription(name);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prescription uploaded')));
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return AppFrame(
      child: Stack(children: [
        Column(children: [
          const SizedBox(height: 10),
          const SearchHeader(),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: PanelCard(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 28, bottom: 14),
                    child: Text('UPLOADED PRESCRIPTIONS', style: AppText.heading(size: 19, color: AppColors.maroon)),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 120),
                      itemCount: app.prescriptions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final p = app.prescriptions[i];
                        return Container(
                          height: 76,
                          decoration: BoxDecoration(color: AppColors.rose, borderRadius: BorderRadius.circular(8)),
                          child: Row(children: [
                            const SizedBox(width: 90, child: Icon(Icons.edit_note_rounded, size: 48, color: Color(0xFFB7872B))),
                            Container(width: 1, height: 60, color: Colors.black12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.name.toUpperCase(), style: AppText.body(size: 12, w: FontWeight.w800)),
                                    const SizedBox(height: 3),
                                    Text(p.patient, style: AppText.body(size: 10, color: Colors.black54)),
                                    Text(_fmt(p.date), style: AppText.body(size: 10, color: Colors.black54)),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        );
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ]),
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Center(
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Material(
                  color: const Color(0xFFD94848),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _upload(context),
                    child: const SizedBox(width: 84, height: 84, child: Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
