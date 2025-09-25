class Codes {
  // TRUE -->
  static final Codes _instance = Codes._internal();

  factory Codes() => _instance;

  Codes._internal();

  // Data
  bool status = true;

  void setStatus(bool newStatus) {
    status = newStatus;
  }

  bool get getStatus => status;

  String get currentSchool => "Bergen County Academies";
  String get adminUsername => "adminbca@gmail.com";
  String get adminPassword => "l3monapp";
  String get adminCode => "12345";
  List get schools => [
    "Bergen County Academies",
    "Bergen County Technical High School - Teterboro Campus",
    "Applied Technology High School",
    "Bergen County Technical High School - Paramus Campus",
    "Career Innovation High School",
    "Bergen County Institutes for Science & Technology @ Northern Valley Regional High School",
  ];
}
