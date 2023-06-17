enum Type {pawn , king , knight , queen , rock , bishop }

class Piece {
  final Type type;
  final bool isWhite;
  final String img;
  Piece({required this.type ,required this.isWhite, required this.img});
}