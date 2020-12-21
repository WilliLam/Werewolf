import 'package:flutter/material.dart';
import 'package:playground/roles.dart';
import 'game.dart';
import 'helpers.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Werewolf")
      ),
      body:
      Container(
          child: RaisedButton(
              child: Text("Play"),
              onPressed: (){
                Navigator.pushNamed(context, '/NumRoles');
              })

      ),
      drawer: mainDrawer(context),
    );
  }
}


//hands out roles for each person privately.
class GiveRoles extends StatefulWidget {
  @override
  _GiveRolesState createState() => _GiveRolesState();
}

class _GiveRolesState extends State<GiveRoles> {

  String role = "?";
  bool showing = false;
  final nameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  Player addPlayer() {
    if (this.role == "Witch") {
      return Witch(nameController.text, this.role);
    } else if (this.role == "Doctor") {
      return Doctor(nameController.text, this.role);
    } else{
      return Player(nameController.text, this.role);
    }
  }

  Future<Object> moveOn(List roles, List<Player> players) {
    if (roles.length > 0){
      return Navigator.pushNamed(context, "/GiveRoles", arguments: GiveRoleArguments(roles, players));
    } else{
      //initialise game
      GameState gameState = GameState(players);
      //{"Werewolf":0, "Villager":0, "Seer":0, "Doctor" : 0, "Witch": 0}

      return Navigator.pushNamed(context, "/Game", arguments: gameState);
    }
  }


  Widget buildBody(List roles, List<Player> players) {
    if ( !this.showing) {
      return Container(
          child: Column(
              children: [TextField(
                decoration: InputDecoration(
                    labelText: "Enter name",
                    hintText: "Jane Smith"
                ),
                controller: nameController,
              ),
                Text("Your role is:"),
                Text("$role",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                RaisedButton(
                  child: Text("Reveal role"),
                  onPressed: () {
                    setState(() {
                      this.showing=true;
                      this.role = roles.removeLast();
                    });

                    players.add(Player(nameController.text, this.role));
                    print(players);
                    print("wtf");
                  },
                )
              ]
          )
      );
    } else {
      //showing, fixed inputs, button goes to next page
      return Container(
          child: Column(
              children: [Text("${players.last.name}"),
                Text("Your role is:"),
                Text("${players.last.role}",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                RaisedButton(
                  child: Text("Next"),
                  onPressed: () {
                    moveOn(roles, players);
                    //  route
                    //   Navigator.pushNamed(context, "/GiveRoles", arguments: GiveRoleArguments(roles, players));
                  },
                )
              ]
          )
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final GiveRoleArguments args = ModalRoute.of(context).settings.arguments;
    List roles = args.roles;
    List players = args.players;
    // print(args.roles);
    return Scaffold(
      appBar: AppBar(title: Text("Hand phone to next player"),),
      body: buildBody(roles,players),
      drawer: mainDrawer(context),

    );
  }
}

class GiveRoleArguments {

  List<String> roles;
  List<Player> players;
  GiveRoleArguments(roles, players) {
    this.roles = roles;
    this.players = players;
  }
}

//select number of players/roles.
class SelectRoles extends StatefulWidget {
  @override
  _SelectRolesState createState() => _SelectRolesState();
}

class _SelectRolesState extends State<SelectRoles> {

  int nPlayers = 0;
  Map<String, int> roles = {"Werewolf":0, "Villager":0, "Seer":0, "Doctor" : 0, "Witch": 0};

  void updateRoles(String role, int amount) {
    roles[role] += amount;
    int sum = 0;
    roles.values.forEach((element) {sum += element;});
    setState(() {
      nPlayers = sum;
    });
    // print(roles);
  }


  void _pushGiveRoles() {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                    title: Text("Enter your name:")
                ),
                body: Text("hello"),
              );
            }
        )
    );
  }

  List<Widget> buildSelection() {
    List<Widget> roleBars = [];
    this.roles.forEach((key, value) {
      roleBars.add(
          Center(
              child: roleBar(key, this.updateRoles)
          )
      );
    });
    roleBars.add(
        Center(
          child: RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/GiveRoles", arguments: GiveRoleArguments(convertToList(roles), new List<Player>()) );
              },
              child: const Text("Next", style: TextStyle(fontSize: 20),)
          ),
        )

    );
    return roleBars;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Number of players: $nPlayers")
      ),
      body: Column(
        children: buildSelection(),
      ),
      drawer: mainDrawer(context),
    );
  }
}



class roleBar extends StatefulWidget{
  int number = 0;
  String name;
  Function updateRoles;
  roleBar(String name, Function updateRoles) {
    this.name = name;
    this.updateRoles = updateRoles;
  }
  @override
  _roleBarState createState() => _roleBarState() ;
// @override
// _roleBar createState() = > _roleBarState();
}

class _roleBarState extends State<roleBar> {
  int number = 0;
  String name;

  @override
  Widget build(BuildContext context) {
    return Container(
        child:Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.remove_circle), onPressed: () {
                if (number >0 ) {
                  setState(() {
                    number--;
                  });
                  widget.updateRoles(widget.name, -1);

                }
              }),
              Column(
                  children: <Widget>[
                    Text(number.toString()),
                    Text(widget.name),
                  ]
              ),
              IconButton(icon: Icon(Icons.add_circle), onPressed: () {setState(() {
                number++;
                widget.updateRoles(widget.name, 1);
              });})
            ]
        )
    );
  }
}

