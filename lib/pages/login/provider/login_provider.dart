import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/login/login_params.dart';
import 'package:green_cart_scanner/service/appwrite/appwrite_login.dart';
import 'package:green_cart_scanner/service/local/local_session.dart';
import 'package:green_cart_scanner/model/session/session_params.dart';
import 'package:green_cart_scanner/pages/navigator/provider/session_provider.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_provider.g.dart';

@Riverpod(keepAlive: true)
class LoginNotifier extends _$LoginNotifier {
  @override
  build() => null;
  final appwriteLogin = AppwriteLogin();

  Future<Either<String, bool>> checkEmailAndPasswordProvider(
      {required LoginParams loginParams}) async {
    Either<String, SessionParams> result =
        await appwriteLogin.checkEmailAndPassword(loginParams: loginParams);

    return result.fold((l) {
      return Left(l);
    }, (r) async {
      Logger().d(r);

      // menyimpan session params ke dalam session local
      String sessionEncode = jsonEncode(r);
      SessionLocal.setSession(sessionEncode);

      // membuat session state
      ref
          .watch(sessionNotifierProvider.notifier)
          .createSessionStateWhenAfterLogin(sessionParams: r);

      return const Right(true);
    });
  }

  Future<Either<String, bool>> loginGoogleAccount() async {
    Either<String, bool> result = await appwriteLogin.loginGoogleAccount();

    return result;
  }
}

      // ini cuma experiment untuk membuat data local dari string menjadi sebuah model
     // String? sessionfromLocal = await SessionLocal.getSession();
      // Logger().d(sessionfromLocal);
      // SessionParams sessionDecode =
      // SessionParams.fromJson(jsonDecode(sessionfromLocal!));

      // print("cek sessionParams with JsonDecode");
      // Logger().d(sessionDecode);