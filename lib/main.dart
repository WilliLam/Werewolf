import 'dart:collection';
import 'dart:developer';
import './roles.dart';
import  './helpers.dart';
import './game.dart';
import './PreGameSetup.dart';
import 'package:flutter/material.dart';


void main() => runApp(App());



class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "OS Werewolf",
        home: Home(),
        routes: <String, WidgetBuilder>{
          '/NumRoles': (context) => SelectRoles(),
          '/GiveRoles': (context) => GiveRoles(),
          '/CloseEyes' : (context) => CloseEyes(),
          '/Werewolf' : (context) => RouteWerewolf(),
          '/Seer' : (context) => RouteSeer(),
          '/Vote' : (context) => Vote(),
          '/AdminPanel' : (context) => AdminPanel()
          // '/Doctor' : (context) => RouterDoctor(),
        },
    );
  }
}

Widget adminPanel(GameState gameState, BuildContext context) {
   void _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      barrierColor: Colors.black,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Player ${index+1}'), CloseButton()]),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name:${gameState.players[index].name} \n'
                    'Role: ${gameState.players[index].role}\n'
                    'Or whatever${() {if (gameState.players[index].alive) {return "Alive";} else {
                    return "Dead";}
                }}'
                    'Alive: ${gameState.players[index].alive}'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Kill'),
              onPressed: () {
                gameState.players[index].alive = false;
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Resurrect'),
              onPressed: () {
                gameState.players[index].alive = true;
                Navigator.of(context).pop();
              },
            ),

          ],
          // backgroundColor: Colors.black,
        );
      },
    );
  }
  return GridView.count(crossAxisCount: 3,
    children:
    List.generate(gameState.players.length, (int index) {
      print(index);
      return Center(
          child: FlatButton(
            child: Column(
                children: [
                  Text(gameState.players[index].name),
                  Text(gameState.players[index].role)
                ]),
            onPressed: () =>  _showMyDialog(index),

          )
      );
    })
    ,);
}

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    GameState gameState = ModalRoute.of(context).settings.arguments;
    return
        adminPanel(gameState, context);
  }
}




class _GameTemplate extends State<StatefulWidget> {
  int _selectedInd = 0;
  // void onTap(int ind) {
  //   setState(() {
  //     _selectedInd = ind;
  //   });
  // }
  // void bottomOnTap(index) {
  //   switch(index){
  //     case 1:
  //       Navigator.pushNamed(context, '/AdminPanel', arguments: gameState);
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    // GameState gameState = ModalRoute.of(context).settings.arguments;
    return Container();
  }
}


class Vote extends StatefulWidget {
  @override
  _VoteState createState() => _VoteState();
}

class _VoteState extends _GameTemplate {
  // @override
  // Widget build(BuildContext context) {
  //   return Container();


  List<Widget> _widgetOptions(GameState gameState) {
    return
      <Widget>[
        Container(
          child: Row(
            children: [
              Text("Vote for someone to lynch."),
              RaisedButton(
                  child: Text("Kill"),
                  onPressed: () {
                    gameState.curTurn = gameState.getNextTurn();
                    Navigator.pushNamed(context, '/${gameState.turnOrder.elementAt(gameState.curTurn)}', arguments: gameState);
                  }),
              RaisedButton(
                  child: Text("Skip"),
                  onPressed: () {
                    gameState.curTurn = gameState.getNextTurn();
                    Navigator.pushNamed(context, '/${gameState.turnOrder.elementAt(gameState.curTurn)}', arguments: gameState);
                  })

            ],
          ),
        ),

      ];
  }


  @override
  Widget build(BuildContext context) {
    GameState gameState = ModalRoute.of(context).settings.arguments;
    gameState.time = "Day";

    // GameState gameState = GameState(players);
    return Scaffold(
        appBar: gameAppBar(gameState),
        body: _widgetOptions(gameState).elementAt(0),
        drawer: mainDrawer(context),
        bottomNavigationBar:
        BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset),
              title: Text('Game'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text('Players'),
            ),

          ],
          currentIndex: _selectedInd,
          selectedItemColor: Colors.amber[800],
          onTap: (index){
            switch(index){
              case 1:
                Navigator.pushNamed(context, '/AdminPanel', arguments: gameState);
            }
          }
        )

    );
  }


}



class RouteSeer extends StatefulWidget {
  @override
  _RouteSeerState createState() => _RouteSeerState();
}

class _RouteSeerState extends _GameTemplate {
  int _selectedInd = 0;
  void onTap(int ind) {
    print(ind);
    print(_selectedInd);
    setState(() {
      _selectedInd = ind;
    });
  }

  List<Widget> _widgetOptions(GameState gameState) {
    return
      <Widget>[
        Container(
          child: Row(
            children: [
              Text("Choose someone to investigate"),
              RaisedButton(
                  child: Text("Kill"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/${gameState.getNextTurn()}',
                        arguments: gameState);
                  }),
              RaisedButton(
                  child: Text("Skip"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/${gameState.getNextTurn()}',
                        arguments: gameState);
                  })

            ],
          ),
        ),

        adminPanel(gameState, context),

      ];
  }
  @override
  Widget build(BuildContext context) {
    GameState gameState = ModalRoute.of(context).settings.arguments;


    // GameState gameState = GameState(players);
    return Scaffold(
        appBar: gameAppBar(gameState),
        body: _widgetOptions(gameState).elementAt(_selectedInd),
        endDrawer: mainDrawer(context),
        bottomNavigationBar:
        BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset),
              title: Text('Game'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text('Players'),
            ),

          ],
          currentIndex: _selectedInd,
          selectedItemColor: Colors.amber[800],
          onTap: onTap,
        )

    );
  }
}



class CloseEyes extends StatefulWidget {
  @override
  _CloseEyesState createState() => _CloseEyesState();
}

class _CloseEyesState extends State<CloseEyes> {

  @override
  Widget build(BuildContext context) {
    GameState gameState = ModalRoute.of(context).settings.arguments;
    gameState.day += 1;
    gameState.time = "Night";
    // GameState gameState = GameState(players);
    return Scaffold(

      appBar: gameAppBar(gameState),
      body: Container(
        child: Row(
          children: [
            Text("Please close eyes"),
            RaisedButton(
                child: Text("Next"),
                onPressed: (){
                  gameState.curTurn = gameState.getNextTurn();
                  Navigator.pushNamed(context, '/${gameState.turnOrder.elementAt(gameState.curTurn)}', arguments: gameState);
                })
          ],
        ),
      ),
      drawer: mainDrawer(context),

    );
  }
}


BottomNavigationBar gameBar(int index, onTap) {

  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.videogame_asset),
        title: Text('Game'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people),
        title: Text('Players'),
      ),

    ],
    currentIndex: index,
    selectedItemColor: Colors.amber[800],
    onTap: onTap,
  );
}

// class _GameRoute extends State<StatefulWidget> {
//   @override
//   Widget build(BuildContext context) {
//
//
//   }
// }






class RouteWerewolf extends StatefulWidget {
  @override
  _RouteWerewolf createState() => _RouteWerewolf();
}


class _RouteWerewolf extends State<RouteWerewolf> {
  int _selectedInd = 0;
  void onTap(int ind) {
    print(ind);
    print(_selectedInd);
    setState(() {
      _selectedInd = ind;
    });
  }

  List<Widget> _widgetOptions(GameState gameState) {
    return
      <Widget>[
        Container(
          child: Row(
            children: [
              Text("Choose someone to kill"),
              RaisedButton(
                  child: Text("Kill"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/${gameState.getNextTurn()}',
                        arguments: gameState);
                  }),
              RaisedButton(
                  child: Text("Skip"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/${gameState.turnOrder.elementAt(gameState.getNextTurn())}',
                        arguments: gameState);
                  })

            ],
          ),
        ),

        adminPanel(gameState, context),

      ];
  }


  @override
  Widget build(BuildContext context) {
    GameState gameState = ModalRoute.of(context).settings.arguments;


      // GameState gameState = GameState(players);
      return Scaffold(
        appBar: gameAppBar(gameState),
        body: _widgetOptions(gameState).elementAt(_selectedInd),
        drawer: mainDrawer(context),
        bottomNavigationBar:
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.videogame_asset),
                title: Text('Game'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                title: Text('Players'),
              ),

            ],
            currentIndex: _selectedInd,
            selectedItemColor: Colors.amber[800],
            onTap: onTap,
          )

      );
  }
}