class Routes {
  static const home = '/';
  static const otc = '/otc';
  static const prescriptions = '/prescriptions';
  static const cart = '/cart';
  static const choosePharmacy = '/choose-pharmacy';
  static const awaitBill = '/await-bill';
  static const billing = '/billing';
  static const payment = '/payment';
  static const awaitAccept = '/await-accept';
  static const tab = '/tab'; // /tab/1, /tab/2, /tab/3 (placeholders)
}

/// How long the fake "waiting for pharmacy" screens last in this demo.
const kDemoDelay = Duration(seconds: 4);
