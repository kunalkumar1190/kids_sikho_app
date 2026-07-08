class HomeworkItem {
  final String symbol;
  final String nameEn;
  final String nameHi;
  final String type; // "text" or "shape"

  HomeworkItem({
    required this.symbol,
    required this.nameEn,
    required this.nameHi,
    this.type = "text",
  });

  factory HomeworkItem.fromJson(Map<String, dynamic> json) {
    return HomeworkItem(
      symbol: json['symbol'] as String,
      nameEn: json['name_en'] as String,
      nameHi: json['name_hi'] as String,
      type: json['type'] as String? ?? "text",
    );
  }
}
