import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
//part 'localisationcar.g.dart';

@JsonSerializable()
class Localisationcar {
  int id;
  double longitude;
  double latitude;
  Localisationcar({
    this.id,
    this.longitude,
    this.latitude,
  });

  Localisationcar.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        longitude = json['longitude'],
        latitude = json['latitude'];
  Map<String, dynamic> toJson() => {
        'id': id,
        'longitude': longitude,
        'latitude': latitude,
      };
}
