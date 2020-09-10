import 'dart:collection';
import 'dart:developer';

class Player {

  String name;
  String role = "?";
  bool alive = true;
  bool marked = false;
  @override
  toString() {
    return "$name is a $role";
  }

  Player(String name,String role) {
    this.name = name;
    this.role = role;
  }
}

class Doctor extends Player{
  int lastSaved = -1;
  Doctor(String name, String role) : super(name, role);
}

class Witch extends Player{
  bool potion = true;
  bool poison = true;

  Witch(String name, String role) : super(name, role);

}
