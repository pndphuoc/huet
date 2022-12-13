import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabItem extends StatelessWidget {
  const TabItem({Key? key}) : super(key: key);

  Widget _tabSelectItem(
      String title, IconData leadingIcon, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(leadingIcon, color: Colors.black54),
              const SizedBox(
                width: 10,
              ),
              Text(title,
                  style: GoogleFonts.readexPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54)),
            ],
          ),

          const Icon(Icons.arrow_forward_ios_outlined,
              size: 17, color: Colors.black54),
          //Download
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    throw UnimplementedError();
  }
}
