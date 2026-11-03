class RecognitionResponse {
  final bool success;
  final bool matched;
  final String matchType; // 'god' | 'landmark'
  final double confidence;
  final int goodMatches;
  final String? message;
  final GodModel? god;
  final LandmarkModel? landmark;
  final LocalityModel? locality;
  final DistrictModel? district;

  RecognitionResponse({
    required this.success,
    required this.matched,
    this.matchType = 'landmark',
    required this.confidence,
    required this.goodMatches,
    this.message,
    this.god,
    this.landmark,
    this.locality,
    this.district,
  });

  factory RecognitionResponse.fromJson(Map<String, dynamic> json) {
    return RecognitionResponse(
      success: json['success'] ?? false,
      matched: json['matched'] ?? false,
      matchType: json['match_type'] ?? (json['god'] != null ? 'god' : 'landmark'),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      goodMatches: json['good_matches'] ?? 0,
      message: json['message'],
      god: json['god'] != null ? GodModel.fromJson(json['god']) : null,
      landmark: json['landmark'] != null
          ? LandmarkModel.fromJson(json['landmark'])
          : null,
      locality: json['locality'] != null
          ? LocalityModel.fromJson(json['locality'])
          : null,
      district: json['district'] != null
          ? DistrictModel.fromJson(json['district'])
          : null,
    );
  }
}

class GodModel {
  final int id;
  final String name;
  final String code;
  final String? title;
  final String? description;
  final String? mantraSloka;
  final String glowColor;
  final String imageUrl;
  final String? audioUrl;
  final String? audioTitle;

  GodModel({
    required this.id,
    required this.name,
    required this.code,
    this.title,
    this.description,
    this.mantraSloka,
    this.glowColor = '#FFD700',
    required this.imageUrl,
    this.audioUrl,
    this.audioTitle,
  });

  factory GodModel.fromJson(Map<String, dynamic> json) {
    return GodModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? json['god_code'] ?? '',
      title: json['title'],
      description: json['description'],
      mantraSloka: json['mantra_sloka'],
      glowColor: json['glow_color'] ?? '#FFD700',
      imageUrl: json['image_url'] ?? json['cloudinary_image_url'] ?? '',
      audioUrl: json['audio_url'] ?? json['cloudinary_audio_url'],
      audioTitle: json['audio_title'],
    );
  }
}

class LandmarkModel {
  final int id;
  final String name;
  final String code;
  final String? description;
  final String referenceImageUrl;

  LandmarkModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.referenceImageUrl,
  });

  factory LandmarkModel.fromJson(Map<String, dynamic> json) {
    return LandmarkModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'],
      referenceImageUrl: json['reference_image_url'] ?? '',
    );
  }
}

class LocalityModel {
  final int id;
  final String name;
  final String? pincode;
  final String? description;
  final List<LocalityFact> facts;

  LocalityModel({
    required this.id,
    required this.name,
    this.pincode,
    this.description,
    required this.facts,
  });

  factory LocalityModel.fromJson(Map<String, dynamic> json) {
    var rawFacts = json['facts'] as List? ?? [];
    return LocalityModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      pincode: json['pincode'],
      description: json['description'],
      facts: rawFacts.map((item) => LocalityFact.fromJson(item)).toList(),
    );
  }
}

class LocalityFact {
  final int id;
  final String title;
  final String factType;
  final String content;
  final String? mediaUrl;
  final String? mediaType;

  LocalityFact({
    required this.id,
    required this.title,
    required this.factType,
    required this.content,
    this.mediaUrl,
    this.mediaType,
  });

  factory LocalityFact.fromJson(Map<String, dynamic> json) {
    return LocalityFact(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      factType: json['fact_type'] ?? 'specialty',
      content: json['content'] ?? '',
      mediaUrl: json['media_url'],
      mediaType: json['media_type'],
    );
  }
}

class DistrictModel {
  final int id;
  final String name;
  final String code;
  final String? state;
  final String? description;
  final List<DistrictFact> facts;

  DistrictModel({
    required this.id,
    required this.name,
    required this.code,
    this.state,
    this.description,
    required this.facts,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    var rawFacts = json['facts'] as List? ?? [];
    return DistrictModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      state: json['state'],
      description: json['description'],
      facts: rawFacts.map((item) => DistrictFact.fromJson(item)).toList(),
    );
  }
}

class DistrictFact {
  final int id;
  final String title;
  final String factType;
  final String content;
  final String? mediaUrl;
  final String? mediaType;
  final String? source;

  DistrictFact({
    required this.id,
    required this.title,
    required this.factType,
    required this.content,
    this.mediaUrl,
    this.mediaType,
    this.source,
  });

  factory DistrictFact.fromJson(Map<String, dynamic> json) {
    return DistrictFact(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      factType: json['fact_type'] ?? 'history',
      content: json['content'] ?? '',
      mediaUrl: json['media_url'],
      mediaType: json['media_type'],
      source: json['source'],
    );
  }
}
