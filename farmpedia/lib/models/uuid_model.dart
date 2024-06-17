class UuidModel {
  final String uuid;

  UuidModel.fromjson(Map<String, dynamic> json) : uuid = json['uuid'];
}
