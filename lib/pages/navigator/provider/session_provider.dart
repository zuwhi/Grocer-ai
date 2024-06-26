import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/account/account_model.dart';
import 'package:green_cart_scanner/service/appwrite/appwrite_profil.dart';
import 'package:green_cart_scanner/service/local/local_session.dart';
import 'package:green_cart_scanner/model/session/session_params.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_provider.g.dart';

@Riverpod(keepAlive: true)
class SessionNotifier extends _$SessionNotifier {
  @override
  SessionState build() => SessionState(
      isLogin: false,
      sessionId: null,
      account: null,
      status: StatusCondition.init);
  AppwriteProfile appwriteProfile = AppwriteProfile();

  //membuat state session ketika selesai login
  createSessionStateWhenAfterLogin(
      {required SessionParams sessionParams}) async {
    findAccount(sessionParams: sessionParams);
  }

  // membuat state session dengan mendapatkan data session params nya dari session local
  createSessionState() async {
    state = SessionState(
        isLogin: false,
        sessionId: null,
        account: null,
        status: StatusCondition.loading);

    String? sessionLocal = await SessionLocal.getSession();
    if (sessionLocal == null) {
      state = SessionState(
          isLogin: false,
          sessionId: null,
          account: null,
          status: StatusCondition.empty);
    }
    SessionParams sessionParams =
        SessionParams.fromJson(jsonDecode(sessionLocal!));
    findAccount(sessionParams: sessionParams);
  }

  // fungsi untuk mendfapatkan accountt dari appwrite dengan mengirimkan parameter yaitu SessionParams
  findAccount({required SessionParams sessionParams}) async {
    Either<String, AccountModel> result =
        await appwriteProfile.findAccount(sessionParams: sessionParams);

    result.fold(
        (l) => Logger().d(l),
        (r) => state = SessionState(
            isLogin: true,
            sessionId: sessionParams.sessionId,
            account: r,
            status: StatusCondition.success));
  }

  // menghancurkan session (session di appwrite dan session di local)
  Future<Either<String, bool>> destroySessionState() async {
    // menghancurkan session di appwrite
    Either<String, bool> resultDestroy =
        await appwriteProfile.logout(sessionId: state.sessionId ?? '');
    return resultDestroy.fold((l) => Left(l), (r) async {
      // menghancurkan session di local
      bool resultDestroyLocal = await SessionLocal.clearSession();
      if (resultDestroyLocal) {
        state = SessionState(isLogin: false, sessionId: null, account: null);
      }
      return const Right(true);
    });
  }
}

// saya mendifinisikan sebuah class yaitu session state yang nantinya akan saya gunakan untuk mendapatkan data akun dari appwrite.
// kenapa saya hanya menyimpan sessionId saja ? karena saya hanya ingin menyimpan session id tersebut agar menjadi tanda telah login saja.
// jika saya melalukan query untuk mendaptkan data session dari appwrite hal tersebut membuat akun tidak permanen karena session di appwrite mempunyai expired
// dan jika memang begitu, berarti aplikasi saya nantinya tidak bisa digunakan secara offline
class SessionState {
  final bool isLogin;
  final String? sessionId;
  final AccountModel? account;
  final StatusCondition? status;

  SessionState({
    required this.isLogin,
    this.sessionId,
    this.account,
    this.status,
  });
}
