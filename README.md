# AUSWAY Pharmacy – Flutter frontend

Frontend only. All data is in-memory placeholder data (`lib/models.dart`, `lib/state.dart`).

## Run
```bash
cd ausway_pharma
flutter create .        # generates android/ios/web folders (keeps lib/ and pubspec.yaml)
flutter pub get
flutter run
```

## Flow
Home → (Upload card) Prescriptions
Home → OTC → Cart → Choose Pharmacy → [Wait for Pharmacy Bill] → Billing → Payment → [Wait until Pharmacy Accepts] → Order accepted → Home

Waiting screens auto-advance after `kDemoDelay` (lib/routes.dart) to simulate the pharmacy.
