import 'package:flutter/material.dart';
import 'pieces.dart';

Color? color; // selected color

class Square extends StatelessWidget {
  final bool isWhite;
  final Piece? piece;
  final bool isSelected;
  final bool isValid;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  const Square({Key? key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.isValid,
    required this.onTap,
    required this.onDoubleTap
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isSelected){color=Colors.lightGreen[400];}
    else if (isValid){color=Colors.lightGreen[400];}
    else {color= isWhite ? Colors.green[900] : Colors.green[300];}
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      onTap: onTap,
      child: Container(
        color: color,
        margin: EdgeInsets.all(isValid ? 6:0),
        child: piece != null ? Image.asset(piece!.img, color: piece!.isWhite ? Colors.white : Colors.black,): null,
      ),
    );
  }
}
