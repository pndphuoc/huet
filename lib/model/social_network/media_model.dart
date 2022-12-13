import 'package:flutter/material.dart';

class Media {
  String url;
  bool isPhoto;

  Media({required this.url, required this.isPhoto});

  Map<String, dynamic> toJson() => {
    'url': url,
    'isPhoto': isPhoto
  };

  static Media fromJson(Map<String, dynamic> json) {
    return Media(url: json['url'], isPhoto: json['isPhoto']);
  }
}