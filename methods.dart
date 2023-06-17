
bool isInBoard(int row,int col){
  return row>=0 && row<8 && col>=0 && col<8;
}

bool isValid(int row , int col, List<List<int>> moves){
  bool isValid=false;
  for (var pos in moves){
    if (pos[0]==row && pos[1]==col){
      isValid=true;
    }
  }
  return isValid;
}