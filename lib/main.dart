import 'dart:collection';
import 'dart:developer';
import './roles.dart';
import 'package:flutter/material.dart';



void main() => runApp(app());



class app extends StatefulWidget {
  @override
  _appState createState() => _appState();
}

class _appState extends State<app> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "OS Werewolf",
        home: Home(),
        routes: <String, WidgetBuilder>{
          '/NumRoles': (context) => SelectRoles(),
          '/GiveRoles': (context) => GiveRoles() 
        },
    );
  }
}



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

        )
    );
  }
}


class Player {

  String name;
  String role = "?";
  bool alive = true;

  @override
  toString() {
    return "$name is a $role";
  }

  Player(String name,String role) {
    this.name = name;
    this.role = role;

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


  // List, Player createPlayerRole(String name, List roles) {
  //   print(roles);
  //   setState(() {
  //     this.role = roles.removeLast();
  //     this.showing = true;
  //
  //   });
  //   return Player(name, role);
  //
  //
  //
  //   // roles.
  // }

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
    } else if (roles.length > 0) {
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
                  //  route
                    Navigator.pushNamed(context, "/GiveRoles", arguments: GiveRoleArguments(roles, players));
                  },
                )
              ]
          )
      );
    }
    else{
      //all roles handed out, start game!
      return Container(
          child: Column(
              children: [Text("${players.last.name}"),
                Text("Your role is:"),
                Text("${players.last.role}",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                Text("Please hand back the phone to the game master."),
                RaisedButton(
                  child: Text("Next"),
                  onPressed: () {
                    //  route
                    Navigator.pushNamed(context, "/Game", arguments: GiveRoleArguments(roles, players));
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
      body: buildBody(roles,players)

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
  Map<String, int> roles = {"Werewolf":0, "Villager":0, "Seer":0, };

  void updateRoles(String role, int amount) {
    roles[role] += amount;
    int sum = 0;
    roles.values.forEach((element) {sum += element;});
    setState(() {
      nPlayers = sum;
    });
    // print(roles);
  }

  List<String> convertToList(Map<String, int> roles) {
    // void assignRole(Map roles) {
    List<String> listRoles = new List<String>();
    roles.forEach((key, value) {
      for (int i = 0; i < value; i++) {
        listRoles.add(key);
      }
    });
    return listRoles..shuffle();
  // roles.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Number of players: $nPlayers")
        ),
        body: Column(
          children: <Widget>[
            Center(
                child: roleBar("Werewolf", this.updateRoles)
            ),
            Center(
                child: roleBar("Villager", this.updateRoles)
            ),
            Center(
                child: roleBar("Seer", this.updateRoles)
            ),
            Center(
              child: RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/GiveRoles", arguments: GiveRoleArguments(convertToList(roles), new List<Player>()) );
                  },
                  child: const Text("Next", style: TextStyle(fontSize: 20),)
              ),
            )
          ],
        )
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

