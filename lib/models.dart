class Medicine {
  final String id;
  final String name;
  final String strength;
  final double price;
  const Medicine(this.id, this.name, this.strength, this.price);
}

class Pharmacy {
  final String id;
  final String name;
  final double distanceKm;
  final String note;
  const Pharmacy(this.id, this.name, this.distanceKm, this.note);
}

class Prescription {
  final String name;
  final String patient;
  final DateTime date;
  const Prescription(this.name, this.patient, this.date);
}

class Coupon {
  final String code;
  final String description;
  const Coupon(this.code, this.description);
}

enum PaymentMethod { upi, card }

// ---- Placeholder data (replace with backend later) ----
const kCatalog = <Medicine>[
  Medicine('m1', 'Paracetamol', '500 mg · 15 tabs', 28),
  Medicine('m2', 'Cetirizine', '10 mg · 10 tabs', 32),
  Medicine('m3', 'Digene Gel', '200 ml', 118),
  Medicine('m4', 'ORS Powder', '21 g · 4 sachets', 76),
  Medicine('m5', 'Cough Lozenges', '10 pcs', 45),
  Medicine('m6', 'Dolo 650', '15 tabs', 32),
  Medicine('m7', 'Cough Syrup', '150 ml', 112),
  Medicine('m8', 'Antacid Powder', '100 g', 98),
  Medicine('m9', 'Pain Relief Gel', '30 g', 135),
  Medicine('m10', 'Antiseptic Ointment', '20 g', 92),
  Medicine('m11', 'Throat Lozenges', '8 pcs', 55),
  Medicine('m12', 'Herbal Digestive', '10 caps', 38),
];

const kPharmacies = <Pharmacy>[
  Pharmacy('p1', 'City Care Pharmacy', 1.2, 'All items in stock'),
  Pharmacy('p2', 'Green Cross Pharmacy', 2.5, 'All items in stock'),
  Pharmacy('p3', 'Life Line Pharmacy', 3.8, 'Some items may be substituted'),
];

const kCoupons = <Coupon>[
  Coupon('AUSWAY10', '10% off on your medicine total'),
  Coupon('FIRST50', 'Flat ₹50 off on your first order'),
];
