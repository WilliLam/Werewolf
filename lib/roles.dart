import 'dart:collection';
import 'dart:developer';

abstract class AbRole {

}

class Doctor extends AbRole{
  int lastSaved = -1;

  @override
  toString() {
    return "Doctor";
  }
}

class Witch extends AbRole{
  bool potion = true;
  bool poison = true;

  @override
  toString() {
    return "Witch";
  }
}

class Werewolf extends AbRole{
  @override
  toString() {
    return "Werewolf";
  }
}

class Villager extends AbRole{
  @override
  toString() {
    return "Villager";
  }
}

class Seer extends AbRole{
  @override
  toString() {
    return "Seer";
  }
}