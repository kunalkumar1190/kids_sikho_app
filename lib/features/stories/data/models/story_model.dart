class StoryModel {
  final int id;
  final String titleEn;
  final String titleHi;
  final String contentEn;
  final String contentHi;
  final String imageUrl;

  StoryModel({
    required this.id,
    required this.titleEn,
    required this.titleHi,
    required this.contentEn,
    required this.contentHi,
    required this.imageUrl,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as int,
      titleEn: json['title_en'] as String,
      titleHi: json['title_hi'] as String,
      contentEn: json['content_en'] as String,
      contentHi: json['content_hi'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_en': titleEn,
      'title_hi': titleHi,
      'content_en': contentEn,
      'content_hi': contentHi,
      'imageUrl': imageUrl,
    };
  }
}
