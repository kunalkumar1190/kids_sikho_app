class NumberModel {
  final String number;
  final String spelling;

  NumberModel({
    required this.number,
    required this.spelling,
  });

  factory NumberModel.fromJson(Map<String, dynamic> json) {
    return NumberModel(
      number: json['number'] as String,
      spelling: json['spelling'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'spelling': spelling,
    };
  }
}
