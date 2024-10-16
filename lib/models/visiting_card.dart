class VisitingCard {
  final String name;
  final String phoneNumber;
  final String email;
  final String company;

  VisitingCard({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.company,
  });

  factory VisitingCard.fromScannedText(String scannedText) {

    final lines = scannedText.split('\n');
    return VisitingCard(
      name: lines.isNotEmpty ? lines[0] : '',
      phoneNumber: _extractPhoneNumber(scannedText),
      email: _extractEmail(scannedText),
      company: lines.length > 1 ? lines[1] : '',
    );
  }

  static String _extractPhoneNumber(String text) {
    final phoneRegex = RegExp(r'\+?[0-9][0-9\s\-\(\)]{7,}\d');
    final match = phoneRegex.firstMatch(text);
    return match != null ? match.group(0)! : '';
  }

  static String _extractEmail(String text) {
    final emailRegex = RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,}\b');
    final match = emailRegex.firstMatch(text);
    return match != null ? match.group(0)! : '';
  }


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'company': company,
    };
  }

  factory VisitingCard.fromJson(Map<String, dynamic> json) {
    return VisitingCard(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      company: json['company'],
    );
  }
}