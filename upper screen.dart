import 'package:flutter/material.dart';
import 'deadPiece.dart';
import 'board.dart';

class Upper extends StatefulWidget {
  const Upper({super.key});

  @override
  State<Upper> createState() => _UpperState();
}

class _UpperState extends State<Upper> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey[800],
      child:Padding(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: whitePiecesTaken.length,
            gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
            itemBuilder: (context,index)=> SizedBox(child: DeadPiece(img: whitePiecesTaken[index].img,isWhite: true),),
            ),
      ));
      }
}
