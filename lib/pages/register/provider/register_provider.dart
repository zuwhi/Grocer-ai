import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/login/login_params.dart';
import 'package:green_cart_scanner/service/appwrite/appwrite_register.dart';
import 'package:green_cart_scanner/model/account/account_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_provider.g.dart';

@Riverpod(keepAlive: true)
class RegisterNotifier extends _$RegisterNotifier {
  @override
  build() {
    return null;
  }

  final appwriteRegister = AppwriteRegister();
  Future<Either<String, LoginParams>> createAccount(
      AccountModel accountRegist) async {
    Either<String, LoginParams> result =
        await appwriteRegister.createAccount(accountRegist);
    return result;
  }
}
