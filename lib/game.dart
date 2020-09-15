import 'dart:collection';

import 'package:flutter/material.dart';

import './roles.dart';

class GameState{
  String time = "Night";
  int day = 0;
  int curTurn = 0;

  List<Player> players;
  LinkedHashSet turnOrder = LinkedHashSet();
  //constructor
  GameState(List<Player> players) {
    this.players = players;
    this.turnOrder.add("CloseEyes");
    List<String> baseTurnOrder = ["Werewolf", "Seer", "Doctor", "Witch"];
    baseTurnOrder.forEach((role) {
      players.forEach((player) {
        if (role == player.role) {
          this.turnOrder.add(role);
        }
      });
    });
    this.turnOrder.add("Vote");
    // print(this.turnOrder);

  }

  int getNextTurn() {
    if (this.curTurn == turnOrder.length-1) {
      return 0;
    } else{
      return this.curTurn += 1;
    }
  }


  void die(int playerN) {
    players[playerN-1].alive = false;
  }

  void resurrect(int playerN) {
    players[playerN-1].alive = true;
  }

  // List<String> getAliveRoles() {
  //
  // }

  checkWin() {
    List<Player> alivePlayers = [];
    players.forEach((player) {
      if (player.alive) {
        alivePlayers.add(player);
      }
    });
  //  werewolf win
    checkWerewolfWin(alivePlayers);
  }

  checkWerewolfWin(List<Player> alivePlayers){
    int werewolves = 0;
    alivePlayers.forEach((player) {
      if (player.role == "Werewolf") {
        werewolves += 1;
      }
    });
    if (werewolves >= alivePlayers.length / 2) {
      return true;
    }
    else {
      return false;
    }
  }

  checkVillagerWin(List<Player> alivePlayers) {
    int werewolves = 0;
    alivePlayers.forEach((player) {
      if (player.role == "Werewolf") {
        werewolves += 1;
      }
    });
    if (werewolves == 0) {
      return true;
    } else{
      return false;
    }
  }

  checkPiperWin(List<Player> alivePlayers) {
    alivePlayers.forEach((player) {
      if (!player.marked) {
        return false;
      } else{
        return true;
      }
    });
  }

}


AppBar gameAppBar(GameState gameState) {
  return AppBar(title: Text("${gameState.time} ${gameState.day.toString()}"));
}