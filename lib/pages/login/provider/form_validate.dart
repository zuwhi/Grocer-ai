import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formValidateProvider =
    ChangeNotifierProvider<FormValidateLogin>((ref) {
  return FormValidateLogin();
});

class FormValidateLogin extends ChangeNotifier {
  bool _isLoad = false;
  bool get isLoad => _isLoad;

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

  FormValidateLogin() {
    _isValidEmail = false;
    _isValidPassword = false;
    _errorPassword = null;
    _errorEmail = null;
  }

  void validatorUsername(String value) {
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

  void validatorNumber(String value) {
    if (value.isEmpty) {
      _errorPassword = 'Password Tidak Boleh Kosong';
      _isValidPassword = false;
    } else if (value.length < 8 || value.length > 15) {
      _errorPassword = 'Panjang password minimal 8 digit ';
      _isValidPassword = false;
    } else {
      _errorPassword = null;
      _isValidPassword = true;
    }
    notifyListeners();
  }

}
