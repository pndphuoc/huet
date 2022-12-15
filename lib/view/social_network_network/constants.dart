import 'package:flutter/material.dart';
import 'package:hue_t/model/social_network/postModel.dart';

const kHeadTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

const kHeadSubtitleTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.black87,
);

bool isUploading = false;
var postInfomation;
bool isCompressing = false;