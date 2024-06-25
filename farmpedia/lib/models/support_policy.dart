class SupportPolicy {
  final int id; // id 필드 추가
  final String title;
  final String content;
  final String applyStart;
  final String applyEnd;
  final String chargeAgency;
  final String eduTarget;
  final int price;
  final String infoUrl;

  SupportPolicy({
    required this.id, // id 필드 추가
    required this.title,
    required this.content,
    required this.applyStart,
    required this.applyEnd,
    required this.chargeAgency,
    required this.eduTarget,
    required this.price,
    required this.infoUrl,
  });

  factory SupportPolicy.fromJson(Map<String, dynamic> json) {
    return SupportPolicy(
      id: json['id'], // id 필드 추가
      title: json['title'],
      content: json['content'],
      applyStart: json['applyStart'],
      applyEnd: json['applyEnd'],
      chargeAgency: json['chargeAgency'],
      eduTarget: json['eduTarget'],
      price: json['price'] ?? 0,
      infoUrl: json['infoUrl'],
    );
  }
}
