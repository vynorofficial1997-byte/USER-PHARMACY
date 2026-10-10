import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';

/// Gradient background + rounded rose panel + optional bottom nav + drawer.
class AppFrame extends StatelessWidget {
  const AppFrame({super.key, required this.child, this.navIndex = 0, this.showNav = true});
  final Widget child;
  final int navIndex;
  final bool showNav;

  void _go(BuildContext c, int i) {
    final current = ModalRoute.of(c)?.settings.name ?? Routes.home;
    final target = i == 0 ? Routes.home : '${Routes.tab}/$i';
    if (current == target) return;
    Navigator.of(c).pushNamedAndRemoveUntil(target, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradTop, AppColors.gradBottom],
          ),
        ),
        child: Column(children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, showNav ? 0 : 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: const Radius.circular(24),
                    bottom: Radius.circular(showNav ? 0 : 24),
                  ),
                  child: ColoredBox(
                    color: AppColors.rose,
                    child: Material(type: MaterialType.transparency, child: child),
                  ),
                ),
              ),
            ),
          ),
          if (showNav) _BottomNav(index: navIndex, onTap: (i) => _go(context, i)),
        ]),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.index, required this.onTap});
  final int index;
  final ValueChanged<int> onTap;

  static const _icons = [
    Icons.medication_rounded,
    Icons.local_hospital_outlined,
    Icons.assignment_ind_outlined,
    Icons.health_and_safety_outlined,
  ];
  static const _labels = ['Pharmacy', 'Hospital', 'Records', 'Insurance'];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.maroon,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(children: [
            for (var i = 0; i < 4; i++)
              Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Tooltip(
                    message: _labels[i],
                    child: Center(
                      child: Icon(_icons[i],
                          size: i == index ? 38 : 34,
                          color: i == index ? Colors.white : AppColors.navInactive),
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    Widget item(IconData i, String t) => ListTile(
          leading: Icon(i, color: AppColors.maroon),
          title: Text(t),
          onTap: () => Navigator.pop(context),
        );
    return Drawer(
      backgroundColor: AppColors.panel,
      child: SafeArea(
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('AUSWAY', style: AppText.display(size: 30, color: AppColors.maroon, spacing: 4)),
          ),
          item(Icons.person_outline, 'My Profile'),
          item(Icons.receipt_long_outlined, 'My Orders'),
          item(Icons.location_on_outlined, 'Saved Addresses'),
          item(Icons.help_outline, 'Help & Support'),
        ]),
      ),
    );
  }
}

class SearchHeader extends StatefulWidget {
  const SearchHeader({super.key, this.initialText = '', this.onChanged, this.onSubmitted});
  final String initialText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  late final TextEditingController _c = TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.12), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(children: [
          IconButton(
            icon: const Icon(Icons.menu, size: 32, color: Colors.grey),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          Container(width: 1, height: 56, color: Colors.black12),
          const SizedBox(width: 12),
          const Icon(Icons.search, size: 30, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _c,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search your tablet...',
                hintStyle: AppText.body(size: 13, color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class PharmacyTitle extends StatelessWidget {
  const PharmacyTitle({super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 8),
        child: Center(child: Text('PHARMACY', style: AppText.title())),
      );
}

class PanelCard extends StatelessWidget {
  const PanelCard({super.key, required this.child, this.padding = EdgeInsets.zero, this.margin = EdgeInsets.zero});
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: child,
      );
}

class MedTile extends StatelessWidget {
  const MedTile({
    super.key,
    required this.label,
    this.caption,
    this.selected = false,
    this.onTap,
    this.onRemove,
  });
  final String label;
  final String? caption;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.18), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Material(
        color: AppColors.tile,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: selected ? const BorderSide(color: AppColors.maroon, width: 2) : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Stack(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(label.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(size: 11, w: FontWeight.w500)),
                  if (caption != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(caption!, textAlign: TextAlign.center, style: AppText.body(size: 9, color: Colors.black54)),
                    ),
                ]),
              ),
            ),
            if (selected && onRemove == null)
              const Positioned(top: 4, right: 4, child: Icon(Icons.check_circle, size: 16, color: AppColors.maroon)),
            if (onRemove != null)
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: onRemove,
                  child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.close, size: 16, color: AppColors.maroon)),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

/// Maroon pill with a ">" knob and ">>>" - tap or swipe right to proceed.
class SlideActionButton extends StatelessWidget {
  const SlideActionButton({super.key, required this.label, this.sublabel, required this.onTap});
  final String label;
  final String? sublabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onHorizontalDragEnd: (d) {
        if ((d.primaryVelocity ?? 0) > 200) onTap();
      },
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: AppColors.maroon,
          borderRadius: BorderRadius.circular(29),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.25), blurRadius: 6, offset: const Offset(0, 3))],
        ),
        child: Row(children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(color: AppColors.rose, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Text('>', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 16),
          Text('>>>', style: AppText.body(size: 20, w: FontWeight.w500, color: Colors.white).copyWith(letterSpacing: 2)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(label, textAlign: TextAlign.right, style: AppText.body(size: 13, w: FontWeight.w800, color: Colors.white)),
                  if (sublabel != null)
                    Text(sublabel!, style: AppText.body(size: 20, w: FontWeight.w700, color: Colors.white)),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class Placeholder404 extends StatelessWidget {
  const Placeholder404({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) =>
      Center(child: Text(text, textAlign: TextAlign.center, style: AppText.body(size: 14, color: Colors.black54)));
}
