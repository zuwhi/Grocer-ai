import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formValidateProfilProvider =
    ChangeNotifierProvider<FormValidateProfil>((ref) {
  return FormValidateProfil();
});

class FormValidateProfil extends ChangeNotifier {


  FormValidateProfil() {

  }


}
