import 'package:flutter/material.dart';
import 'router.dart';
import 'routes.dart';
import 'state.dart';
import 'theme.dart';

void main() => runApp(const AuswayPharmaApp());

class AuswayPharmaApp extends StatefulWidget {
  const AuswayPharmaApp({super.key});
  @override
  State<AuswayPharmaApp> createState() => _AuswayPharmaAppState();
}

class _AuswayPharmaAppState extends State<AuswayPharmaApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'AUSWAY Pharmacy',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        initialRoute: Routes.home,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
