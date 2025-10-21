import 'dart:typed_data';
import 'package:flutter/material.dart';

class UserInfo {
  static ValueNotifier<String> fullname = ValueNotifier("");
  static ValueNotifier<String> phone = ValueNotifier("");
  static ValueNotifier<String> balance = ValueNotifier("0.00");
  static ValueNotifier<String> rfid = ValueNotifier("");
  static Uint8List? userImageBytes; // store profile image globally
}
