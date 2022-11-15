import 'package:flutter/material.dart';

class AllReviews extends StatefulWidget {
  const AllReviews({Key? key, required this.hotelId}) : super(key: key);
  final int hotelId;
  @override
  State<AllReviews> createState() => _AllReviewsState();
}

class _AllReviewsState extends State<AllReviews> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("All reviews of this hotel is here"),
    );
  }
}
