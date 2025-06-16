part of site_ratings_module;

class PlacesEntity extends Decodable<PlacesEntity> {
  List<PlaceEntity>? places;

  PlacesEntity({
    this.places,
  });

  PlacesEntity.fromJson(Map<String, dynamic> json) {
    if (json['places'] != null) {
      places = <PlaceEntity>[];
      json['places'].forEach((v) {
        places!.add(PlaceEntity.fromJson(v));
      });
    }
  }

  @override
  PlacesEntity decode(dynamic data) => PlacesEntity.fromJson(
        data is String ? json.decode(data) : data,
      );
}

class PlaceEntity {
  String? id;

  PlaceEntity({
    this.id,
  });

  PlaceEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}

class PlaceRatingEntity extends Decodable<PlaceRatingEntity> {
  double? rating;

  PlaceRatingEntity({
    this.rating,
  });

  PlaceRatingEntity.fromJson(Map<String, dynamic> json) {
    rating = parseRating(json);
  }

  double parseRating(Map<String, dynamic> json) {
    final ratingJson = json['rating'];
    final num? ratingData = ratingJson;
    double ratingTemp = 0;
    if (ratingData != null && ratingData.toString().contains('.')) {
      ratingTemp = ratingData.toDouble();
    } else {
      ratingTemp = ratingData?.toDouble() ?? noRating;
    }
    return ratingTemp > 0 ? ratingTemp : noRating;
  }

  @override
  PlaceRatingEntity decode(dynamic data) => PlaceRatingEntity.fromJson(
        data is String ? json.decode(data) : data,
      );

  static const double error = -9999;
  static const double noRating = -1;
}
