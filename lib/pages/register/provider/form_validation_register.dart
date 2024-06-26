import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formValidateRegisterProvider =
    ChangeNotifierProvider<FormValidateRegister>((ref) {
  return FormValidateRegister();
});

class FormValidateRegister extends ChangeNotifier {
  bool _isLoad = false;
  bool get isLoad => _isLoad;

  String? _username;
  String? get username => _username;

  String? _errorUsername;
  String? get errorUsername => _errorUsername;

  bool _isValidUsername = false;
  bool get isValidUsername => _isValidUsername;

  String? _email;
  String? get email => _email;

  String? _errorEmail;
  String? get errorEmail => _errorEmail;

  bool _isValidEmail = false;
  bool get isValidEmail => _isValidEmail;

  String? _errorPassword;
  String? get errorPassword => _errorPassword;

  bool _isValidPassword = false;
  bool get isValidPassword => _isValidPassword;

  FormValidateRegister() {
    _isValidUsername = false;
    _isValidEmail = false;
    _isValidPassword = false;
    _errorPassword = null;
    _errorEmail = null;
  }

  void validatorUsername(String value) {
    if (value.isEmpty) {
      _errorUsername = 'Username tidak boleh kosong';
      _isValidUsername = false;
    } else {
      _errorUsername = null;
      _isValidUsername = true;
    }
    notifyListeners();
  }

  void validatorEmail(String value) {
    if (value.isEmpty) {
      _errorEmail = 'Email tidak boleh kosong';
      _isValidEmail = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      _errorEmail = 'Masukkan Email Yang benar';
      _isValidEmail = false;
    } else {
      _email = value;
      _errorEmail = null;
      _isValidEmail = true;
    }
    notifyListeners();
  }

  void validatorPassword(String value) {
    if (value.isEmpty) {
      _errorPassword = 'Password Tidak Boleh Kosong';
      _isValidPassword = false;
    } else if (value.length < 8) {
      _errorPassword = 'Panjang password minimal 8 digit ';
      _isValidPassword = false;
    } else {
      _errorPassword = null;
      _isValidPassword = true;
    }
    notifyListeners();
  }

  void changeLoad() {
    _isLoad = !_isLoad;
    notifyListeners();
  }
}
