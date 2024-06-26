import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/account/account_model.dart';
import 'package:green_cart_scanner/model/login/login_params.dart';
import 'package:green_cart_scanner/service/appwrite/appwrite_profil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profil_provider.g.dart';

@Riverpod(keepAlive: false)
class ProfilNotifier extends _$ProfilNotifier {
  @override
  build() => null;
  AppwriteProfile appwriteProfile = AppwriteProfile();

  Future<Either<String, bool>> updateAccount(
      {required AccountModel account}) async {
    Either<String, bool> resultUpdate =
        await appwriteProfile.updateProfilAccount(account);
    return resultUpdate;
  }

  Future<Either<String, bool>> updateEmailAndPassword(
      {required LoginParams loginParams}) async {
    Either<String, bool> result = await appwriteProfile
        .updateEmailAndPasswordAccount(loginParams: loginParams);
    return result;
  }
}
