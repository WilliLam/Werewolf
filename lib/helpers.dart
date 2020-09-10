import 'package:flutter/material.dart';

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


Drawer mainDrawer(BuildContext context) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Drawer Header'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Help'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Restart Game'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            _showMyDialog(context);
          },
        ),
      ],
    ),
  );
}

Future<void> _showMyDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Restart Game'),
              Text('Are you sure you want to go back to the main menu?'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/');
            },
          ),

        ],
      );
    },
  );
}
