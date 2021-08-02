import 'package:flutter/material.dart';

enum Player { Player1, Player2, None }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List playerStates =
      List.generate(3, (i) => List.generate(3, (index) => Player.None));
  var player = Player.None;
  var currentPlayer = Player.Player1;
  var result = Player.None;
  updatePlayerIndex(index, i) {
    playerStates[index][i] = player;
  }

  checkLogic() {
    var player1Count = 0;
    var player2Count = 0;
    //check Colun wise
    for (var i = 0; i < playerStates.length; i++) {
      if (player1Count == 3) break;
      if (player2Count == 3) break;
      for (var j = 0; j < playerStates[i].length; j++) {
        if (playerStates[j][i] == Player.Player1) {
          player1Count++;
          print(player1Count);
        } else
          player1Count = 0;
        if (playerStates[j][i] == Player.Player2) {
          player2Count++;
          if (player2Count == 3) break;
        } else
          player2Count = 0;
      }
    }
//Check Diagonally from left
    for (var i = 0; i < playerStates.length; i++) {
      if (player1Count == 3) break;
      if (player2Count == 3) break;
      for (var j = 0; j < playerStates[i].length; j++) {
        if (i == j) {
          if (playerStates[j][i] == Player.Player1) {
            player1Count++;
            print(player1Count);
          } else
            player1Count = 0;
          if (playerStates[j][i] == Player.Player2) {
            player2Count++;
          } else
            player2Count = 0;
        }
      }
    }
//CheckDiagonally from right
    if (playerStates[0][2] == Player.Player1 &&
        playerStates[1][1] == Player.Player1 &&
        playerStates[2][0] == Player.Player1) result = Player.Player1;

    if (playerStates[0][2] == Player.Player2 &&
        playerStates[1][1] == Player.Player2 &&
        playerStates[2][0] == Player.Player2) result = Player.Player2;

    if (player1Count == playerStates.length) result = Player.Player1;
    if (player2Count == playerStates.length) result = Player.Player2;
//Check Row wise
    playerStates.forEach((element) {
      if (element.indexOf(Player.Player2) == -1 &&
          element.indexOf(Player.None) == -1) {
        result = Player.Player1;
      } else if (element.indexOf(Player.Player1) == -1 &&
          element.indexOf(Player.None) == -1) {
        result = Player.Player2;
      }
    });
    //In case of Game tie
    if (playerStates.every((element) => element.indexOf(Player.None) == -1)) {
      result = null;
      return result;
    }
    return result;
  }

  showResultDialog(res) {
    print(res);
    if (res != Player.None) {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(res == null
                  ? "Oops!! Game Tied"
                  : res == Player.Player1
                      ? "Player 1 wins!!"
                      : "Player 2 wins!!"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"),
                  ),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("Tic Tac Toe"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  playerStates = List.generate(
                      3, (i) => List.generate(3, (index) => Player.None));
                  player = Player.None;
                  result = Player.None;
                  currentPlayer = Player.Player1;
                });
              })
        ],
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width > 600
              ? 600
              : MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            padding: EdgeInsets.all(20),
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (index == 0)
                    Container(
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      child: Text(
                        currentPlayer == Player.Player1
                            ? "Player 1 "
                            : "Player 2",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < 3; i++)
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                margin: EdgeInsets.all(3),
                                height: constraints.maxWidth,
                                child: InkWell(
                                  onTap: result != Player.None
                                      ? null
                                      : () {
                                          if (playerStates[index][i] ==
                                              Player.None)
                                            setState(() {
                                              if (player == Player.None) {
                                                player = Player.Player1;
                                                currentPlayer = Player.Player2;
                                              } else if (player ==
                                                  Player.Player2) {
                                                player = Player.Player1;
                                                currentPlayer = Player.Player2;
                                              } else {
                                                player = Player.Player2;
                                                currentPlayer = Player.Player1;
                                              }
                                              updatePlayerIndex(index, i);
                                              result = checkLogic();
                                              setState(() {});
                                              showResultDialog(result);
                                            });
                                        },
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color:
                                          playerStates[index][i] == Player.None
                                              ? Colors.white
                                              : playerStates[index][i] ==
                                                      Player.Player1
                                                  ? Colors.blue
                                                  : Colors.red[900],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        playerStates[index][i] != Player.None
                                            ? playerStates[index][i] ==
                                                    Player.Player1
                                                ? "X"
                                                : "O"
                                            : "",
                                        style: TextStyle(
                                            fontSize: 45,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
            itemCount: playerStates.length,
          ),
        ),
      ),
    );
  }
}
