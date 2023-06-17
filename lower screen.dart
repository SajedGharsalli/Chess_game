import 'package:flutter/material.dart';
import 'deadPiece.dart';
import 'board.dart';

class Lower extends StatefulWidget {
const Lower({super.key});

@override
State<Lower> createState() => _UpperState();
}

class _UpperState extends State<Lower> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey[800],
    child:GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: blackPiecesTaken.length,
      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
      itemBuilder: (context,index)=> SizedBox(child: DeadPiece(img: blackPiecesTaken[index].img,isWhite: false,),
      ),
      ));
      }
}
