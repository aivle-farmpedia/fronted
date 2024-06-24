class SearchKeyword {
  final String imageUrl;
  final String name;
  final String cropName;
  final int id;

  SearchKeyword({
    required this.imageUrl,
    required this.name,
    required this.cropName,
    required this.id,
  });

  factory SearchKeyword.fromJson(Map<String, dynamic> json) {
    return SearchKeyword(
      imageUrl: json['imageUrl'],
      name: json['name'],
      cropName:
          json['cropName'] ?? json['name'], // Use name if cropName is missing
      id: json['id'],
    );
  }
}
