class Crop {
  final int cropId;
  final String cropName;
  final double? areaPerYield;
  final double? timePerYield;
  final String? cultivationUrl;

  Crop({
    required this.cropId,
    required this.cropName,
    this.areaPerYield,
    this.timePerYield,
    this.cultivationUrl,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      cropId: json['cropId'],
      cropName: json['cropName'],
      areaPerYield: json['areaPerYield']?.toDouble(),
      timePerYield: json['timePerYield']?.toDouble(),
      cultivationUrl: json['cultivationUrl'],
    );
  }
}

class Variety {
  final String name;
  final String purpose;
  final String skill;
  final String imageUrl;

  Variety({
    required this.name,
    required this.purpose,
    required this.skill,
    required this.imageUrl,
  });

  factory Variety.fromJson(Map<String, dynamic> json) {
    return Variety(
      name: json['name'] ?? "",
      purpose: json['purpose'] ?? "",
      skill: json['skill'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
    );
  }
}

class PriceEntry {
  final String priceDate;
  final double price;

  PriceEntry({
    required this.priceDate,
    required this.price,
  });

  factory PriceEntry.fromJson(Map<String, dynamic> json) {
    return PriceEntry(
      priceDate: json['priceDate'] ?? "",
      price: json['price']?.toDouble() ?? 0.0,
    );
  }
}

class CropProcess {
  final int processOrder;
  final String task;
  final String description;

  CropProcess({
    required this.processOrder,
    required this.task,
    required this.description,
  });

  factory CropProcess.fromJson(Map<String, dynamic> json) {
    return CropProcess(
      processOrder: json['processOrder'],
      task: json['task'] ?? "",
      description: json['description'] ?? "",
    );
  }
}

class CropInfo {
  final Crop crop;
  final List<Variety> varieties;
  final List<PriceEntry> priceEntries;
  final List<CropProcess> cropProcesses;

  CropInfo({
    required this.crop,
    required this.varieties,
    required this.priceEntries,
    required this.cropProcesses,
  });

  factory CropInfo.fromJson(Map<String, dynamic> json) {
    var varietiesJson = json['varieties'] as List<dynamic>? ?? [];
    var priceEntriesJson = json['priceEntries'] as List<dynamic>? ?? [];
    var cropProcessesJson = json['cropProcesses'] as List<dynamic>? ?? [];

    List<Variety> varietiesList =
        varietiesJson.map((i) => Variety.fromJson(i)).toList();
    List<PriceEntry> priceEntriesList =
        priceEntriesJson.map((i) => PriceEntry.fromJson(i)).toList();
    List<CropProcess> cropProcessesList =
        cropProcessesJson.map((i) => CropProcess.fromJson(i)).toList();

    return CropInfo(
      crop: Crop.fromJson(json['crop']),
      varieties: varietiesList,
      priceEntries: priceEntriesList,
      cropProcesses: cropProcessesList,
    );
  }
}
