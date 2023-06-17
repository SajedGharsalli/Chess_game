import 'package:flutter/material.dart';

class DeadPiece extends StatelessWidget {
  final String img;
  final bool isWhite;
  const DeadPiece({super.key,required this.img,required this.isWhite});

  @override
  Widget build(BuildContext context) {
    Color color= isWhite ? Colors.white : Colors.black;
    return Image.asset(img,color: color,);
  }
}
