import 'dart:math';

import 'package:flutter/material.dart';
import 'square.dart';
import 'pieces.dart';
import 'methods.dart';

List<Piece> blackPiecesTaken = []; // list of black captured pieces
List<Piece> whitePiecesTaken = []; // list of white captured pieces

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  late List<List<Piece?>> board; // 2d list ===> board game

  // list of valid moves
  List<List<int>> validMoves = [];
  // list of advanced valid moves
  List<List<int>> advancedValidMoves = [];


  // selected piece
  Piece? selectedPiece;
  int selectRow = -1; //default value of row if no piece is selected
  int selectCol = -1; //default value of column if no piece is selected
  // turns
  bool isWhiteTurn = true;
  // track initial kings positions
  List<int>? whiteKing = [7, 4];
  List<int>? blackKing = [0, 4];
  // check state
  bool check = false;

  //initialize the board game
  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  // init board
  void _initBoard() {
    //first all places are null
    List<List<Piece?>> game =
        List.generate(8, (index) => List.generate(8, (index) => null));

    //pawn
    for (int i = 0; i <= 7; i++) {
      game[1][i] =
          Piece(type: Type.pawn, isWhite: false, img: 'lib/assets/pawn.png');
      game[6][i] =
          Piece(type: Type.pawn, isWhite: true, img: 'lib/assets/pawn.png');
    }
    //king
    game[0][4] =
        Piece(type: Type.king, isWhite: false, img: 'lib/assets/king.png');
    game[7][4] =
        Piece(type: Type.king, isWhite: true, img: 'lib/assets/king.png');
    //rock
    game[0][0] =
        Piece(type: Type.rock, isWhite: false, img: 'lib/assets/rock.png');
    game[0][7] =
        Piece(type: Type.rock, isWhite: false, img: 'lib/assets/rock.png');
    game[7][0] =
        Piece(type: Type.rock, isWhite: true, img: 'lib/assets/rock.png');
    game[7][7] =
        Piece(type: Type.rock, isWhite: true, img: 'lib/assets/rock.png');
    //bishop
    game[0][2] =
        Piece(type: Type.bishop, isWhite: false, img: 'lib/assets/bishop.png');
    game[0][5] =
        Piece(type: Type.bishop, isWhite: false, img: 'lib/assets/bishop.png');
    game[7][5] =
        Piece(type: Type.bishop, isWhite: true, img: 'lib/assets/bishop.png');
    game[7][2] =
        Piece(type: Type.bishop, isWhite: true, img: 'lib/assets/bishop.png');
    //knight
    game[0][1] =
        Piece(type: Type.knight, isWhite: false, img: 'lib/assets/knight.png');
    game[0][6] =
        Piece(type: Type.knight, isWhite: false, img: 'lib/assets/knight.png');
    game[7][1] =
        Piece(type: Type.knight, isWhite: true, img: 'lib/assets/knight.png');
    game[7][6] =
        Piece(type: Type.knight, isWhite: true, img: 'lib/assets/knight.png');
    //queen
    game[0][3] =
        Piece(type: Type.queen, isWhite: false, img: 'lib/assets/queen.png');
    game[7][3] =
        Piece(type: Type.queen, isWhite: true, img: 'lib/assets/queen.png');

    //initialize the board
    board = game;
  }

  // piece selection
  void selectPiece(int row, int col) {
    setState(() {
      // no piece selected
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectRow = row;
          selectCol = col;
        }
      }
      // a piece is already selected
      else if (board[row][col] != null &&
          selectedPiece!.isWhite == board[row][col]!.isWhite) {
        selectedPiece = board[row][col];
        selectRow = row;
        selectCol = col;
      }
      //when a piece is selected you can move it
      else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        move(row, col);
      }
      validMoves = makeAdvancedMoves(row, col, selectedPiece, true);
    });
  }

  // init valid moves
  List<List<int>> makeMoves(int row, int col, Piece? piece) {
    List<List<int>> moves = [];
    if (piece == null) {
      return [];
    }
    switch (piece!.type) {
      // PAWN
      case Type.pawn:
        int direction = piece.isWhite ? -1 : 1;
        // pawn moves 1 if square not occupied
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          moves.add([row + direction, col]);
        }
        //pawn moves 2 if square is in initial position
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null) {
            moves.add([row + 2 * direction, col]);
          }
        }
        //pawn kill diagonally
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col-1] != null &&
            board[row + direction][col-1]!.isWhite != piece.isWhite) {
          moves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col+1] != null &&
            board[row + direction][col+1]!.isWhite !=piece.isWhite) {
          moves.add([row + direction, col + 1]);
        }
        break;
      // KING
      case Type.king:
        List<List<int>> kMoves = [
          [1, 0],
          [-1, 0],
          [0, 1],
          [0, -1],
          [1, 1],
          [1, -1],
          [-1, 1],
          [-1, -1]
        ];
        for (var m in kMoves) {
          int x = row + m[0];
          int y = col + m[1];
          if (!isInBoard(x, y)) {
            continue;
          }
          if (board[x][y] != null) {
            if (board[x][y]!.isWhite != piece.isWhite) {
              moves.add([x, y]); // kill
            }
            continue; // blocked by same color
          }
          moves.add([x, y]);
        }
        break;
      // ROCK
      case Type.rock:
        // moves vert and hor
        List<List<int>> rMoves = [
          [1, 0],
          [-1, 0],
          [0, 1],
          [0, -1]
        ];
        for (var m in rMoves) {
          int i = 1;
          while (true) {
            int x = row + i * m[0];
            int y = col + i * m[1];
            if (!isInBoard(x, y)) {
              break;
            }
            if (board[x][y] != null) {
              if (board[x][y]!.isWhite != piece.isWhite) {
                moves.add([x, y]); //kill
              }
              break; //blocked by same color
            }
            moves.add([x, y]);
            i++;
          }
        }
        break;
      //KNIGHT
      case Type.knight:
        //knight moves and kills as L
        List<List<int>> knMoves = [
          [2, 1],
          [-2, 1],
          [2, -1],
          [-2, -1],
          [1, 2],
          [-1, 2],
          [1, -2],
          [-1, -2]
        ];
        for (var m in knMoves) {
          int x = row + m[0];
          int y = col + m[1];
          if (!isInBoard(x, y)) {
            continue;
          }
          if (board[x][y] != null) {
            if (board[x][y]!.isWhite != piece.isWhite) {
              moves.add([x, y]); // kill
            }
            continue; // blocked by same color
          }
          moves.add([x, y]);
        }
        break;
      //QUEEN
      case Type.queen:
        List<List<int>> qMoves = [
          [1, 0],
          [-1, 0],
          [0, 1],
          [0, -1],
          [1, 1],
          [1, -1],
          [-1, 1],
          [-1, -1]
        ];
        for (var m in qMoves) {
          int i = 1;
          while (true) {
            int x = row + i * m[0];
            int y = col + i * m[1];
            if (!isInBoard(x, y)) {
              break;
            }
            if (board[x][y] != null) {
              if (board[x][y]!.isWhite != piece.isWhite) {
                moves.add([x, y]); //kill
              }
              break; //blocked by same color
            }
            moves.add([x, y]);
            i++;
          }
        }
        break;
      // BIOSHOP
      case Type.bishop:
        // diagonal
        List<List<int>> bMoves = [
          [1, 1],
          [1, -1],
          [-1, 1],
          [-1, -1],
        ];
        for (var m in bMoves) {
          int i = 1;
          while (true) {
            int x = row + i * m[0];
            int y = col + i * m[1];
            if (!isInBoard(x, y)) {
              break;
            }
            if (board[x][y] != null) {
              if (board[x][y]!.isWhite != piece.isWhite) {
                moves.add([x, y]); //kill
              }
              break; //blocked by same color
            }
            moves.add([x, y]);
            i++;
          }
        }
        break;
    }
    // RETURN MOVES VALUES
    return moves;
  }
  // advanced valid moves
  List<List<int>> makeAdvancedMoves(int row,int col,Piece? piece,bool check){
    List<List<int>> realMoves = [];
    List<List<int>> Moves = makeMoves(row, col, piece);
    // filter moves that causes checkmate
    if (check){
      for (var m in Moves){
        int endRow=m[0];
        int endCol=m[1];
        // simulate checkmate
        if(safe(row,col,endRow,endCol,piece!)){
          realMoves.add(m);
        }
      }
    }
    else{
      realMoves=Moves;
    }
    return realMoves;
  }
  // simulate future moves
  bool safe(int startRow,int startCol,int endRow, int endcol, Piece piece){
    //save board
    Piece? originalPiece=board[endRow][endcol];
    //if piece is king , save its position
    List<int>? originalKingPosition;
    if (piece.type==Type.king){
      originalKingPosition= piece.isWhite ? whiteKing : blackKing;
      //update the position
      if (piece.isWhite){
        whiteKing=[endRow,endcol];
      }
      else{
        blackKing=[endRow,endcol];
      }
    }
    //simulate moves
    board[endRow][endcol]=piece;
    board[startRow][startCol]=null;
    //check if checkmate
    bool checkMate=ischeck(piece.isWhite);
    //restore board
    board[startRow][startCol]=piece;
    board[endRow][endcol]=originalPiece;
    //if king , restore its position
    if(piece.type==Type.king){
      if(originalKingPosition!=null){
        if(piece.isWhite){
          whiteKing=originalKingPosition;
        }
        else{
          blackKing=originalKingPosition;
        }
      }
    }
    // if check = true ====> it is not safe
    return !checkMate;
  }

  // move piece
  void move(int newRow, int newCol) {
    // if piece killed add it to the capture list
    if (board[newRow][newCol] != null) {
      Piece? capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
    }
    // check is the piece moved is king
    if (selectedPiece!.type== Type.king){
      if (selectedPiece!.isWhite){
        whiteKing=[newRow,newCol];
      }
      else{
        blackKing=[newRow,newCol];
      }
    }
    // move to new square and clear the old one
    board[newRow][newCol] = selectedPiece;
    board[selectRow][selectCol] = null;
    // if there is a check
    if (ischeck(isWhiteTurn)) {
      check = true;
    } else {
      check = false;
    }
    // clear
    setState(() {
      selectedPiece = null;
      selectRow = -1;
      selectCol = -1;
      validMoves = [];
    });
    isWhiteTurn = !isWhiteTurn;
  }
  //is king in check
  bool ischeck(bool isWhiteking) {
    List<int>? kinPosition = isWhiteking ? whiteKing : blackKing;
    if (kinPosition==null){
      return false;
    }
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteking) {
          continue;
        }
        List<List<int>> pVM = makeAdvancedMoves(i, j, board[i][i], false);
        if (pVM.any((element) => element[0] == kinPosition[0] &&
            element[1] == kinPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 64,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8),
          itemBuilder: (context, index) {
            int x = index ~/ 8; // row
            int y = index % 8; //column

            return Square(
              isWhite: (x + y) % 2 == 0,
              piece: board[x][y],
              isSelected: selectRow == x && selectCol == y,
              isValid: isValid(x, y, validMoves),
              onTap: () {
                selectPiece(x, y);
              },
              onDoubleTap: () {
                setState(() {
                  selectedPiece = null;
                  selectRow = -1;
                  selectCol = -1;
                  validMoves = [];
                });
              },
            );
          }),
    );
  }
}
