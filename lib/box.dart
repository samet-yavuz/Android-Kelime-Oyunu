import 'package:flutter/material.dart';

class Box {
  late String harf;
  late double renk;
  late Container konteyner;
  late bool isFrozen;
  Box(harf, renk, konteyner) {
    this.harf = harf;
    this.renk = renk;
    this.konteyner = konteyner;
    this.isFrozen = false;
  }
  String get_harf() {
    return this.harf;
  }

  bool get_frozen() {
    return this.isFrozen;
  }

  double get_renk() {
    return this.renk;
  }

  Container get_container() {
    return this.konteyner;
  }

  void set_harf(harf) {
    this.harf = harf;
  }

  void set_frozen(frozen) {
    this.isFrozen = frozen;
  }

  void set_renk(renk) {
    this.renk = renk;
  }

  void set_container(konteyner) {
    this.konteyner = konteyner;
  }
}
