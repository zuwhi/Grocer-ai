import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/login/login_params.dart';
import 'package:green_cart_scanner/service/helper/appwrite_client_helper.dart';
import 'package:green_cart_scanner/model/session/session_params.dart';
import 'package:logger/logger.dart';

class AppwriteLogin {
  late Client _appwriteClient;
  late Databases databases;
  late final Account account;

  AppwriteLogin() {
    _appwriteClient = AppwriteClientHelper.instance.appwriteClient;
    databases = Databases(_appwriteClient);
    account = Account(_appwriteClient);
  }

  Future<Either<String, SessionParams>> checkEmailAndPassword(
      {required LoginParams loginParams}) async {
    try {
      //memuat session dengan mengecek email dan password
      Session session = await account.createEmailSession(
          email: loginParams.email, password: loginParams.password);

      // mendapatkan account dari session di atas
      User authCollection = await account.get();

      // menyimpan session id dan account id pada session params
      SessionParams sessionParams =
          SessionParams(sessionId: session.$id, accountId: authCollection.$id);
      return Right(sessionParams);
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        return const Left("Masukkan Email dan Password yang benar");
      }
      if (e.code == 401) {
        return const Left("Masukkan Email dan Password yang benar");
      }
      return Left("terdapat kesalahan : $e");
    } catch (e) {
      return Left("terdapat kesalahan : $e");
    }
  }

  Future<Either<String, bool>> loginGoogleAccount() async {
    try {
      final result = await account.createOAuth2Session(provider: "google");
      Logger().d("Login by google");
      Logger().d(result);
      Logger().d(account);
      User authCollection = await account.get();
      Logger().d(authCollection);
      return const Right(true);
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        return const Left("Masukkan Email dan Password yang benar");
      }
      if (e.code == 401) {
        return const Left("Masukkan Email dan Password yang benar");
      }
      return Left("terdapat kesalahan : $e");
    } catch (e) {
      return Left("terdapat kesalahan : $e");
    }
  }
}
