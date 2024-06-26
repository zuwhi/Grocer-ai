import 'package:appwrite/appwrite.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/constant/appwrite_contant.dart';
import 'package:green_cart_scanner/model/login/login_params.dart';
import 'package:green_cart_scanner/service/helper/appwrite_client_helper.dart';
import 'package:green_cart_scanner/model/account/account_model.dart';
import 'package:uuid/uuid.dart';

class AppwriteRegister {
  late Client _appwriteClient;
  late Databases databases;
  late final Account account;
  AppwriteRegister() {
    _appwriteClient = AppwriteClientHelper.instance.appwriteClient;
    databases = Databases(_appwriteClient);
    account = Account(_appwriteClient);
  }

  Future<Either<String, LoginParams>> createAccount(AccountModel accountRegist) async {
    try {
      // saya mendifinisikan unique ID ke dalam variable tersendiri agar ID Auth dan ID Akun bisa memiliki id yang sama
      var uuid = const Uuid();
      var userId = uuid.v4();

      dynamic urlProfil;
      dynamic fileId;

      // membuat akun user di appwritek
      await account.create(
        userId: userId,
        email: accountRegist.email!,
        password: accountRegist.password!,
        name: accountRegist.name,
      );

      //sebelum membuat akun saya simpan dulu gambar ke dalam bucket
      if (accountRegist.image != null) {
        final storage = Storage(_appwriteClient);
        final responseImg = await storage.createFile(
          bucketId: Appconstants.profilBucketID,
          fileId: ID.unique(),
          file: InputFile.fromPath(
              path: accountRegist.image.path,
              filename: accountRegist.image.name),
        );
        //saya membuat sebuah url agar dapat mengakses ke bucket tersebut hanya dengan url dan url ini saya masukkan ke dalam attribute akun yaitu image
        urlProfil =
            '${Appconstants.endpoint}/storage/buckets/${responseImg.bucketId}/files/${responseImg.$id}/view?project=${Appconstants.projectid}&mode=admin';
        fileId = responseImg.$id;
      }

      // karena appwrite tidak bisa custom attribute maka saya membuat collection baru yaitu collection akun agar memiliki banyak attribute
      await databases.createDocument(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.collectionAkun,
          documentId: userId,
          data: {
            'alamat': accountRegist.alamat,
            'telepon': accountRegist.telepon,
            'role': accountRegist.role,
            'image': urlProfil,
            'fileId': fileId
          }
          );

      return Right(LoginParams(email: accountRegist.email ??"", password: accountRegist.password ??""));
    } on AppwriteException catch (e) {
      if (e.code == 409) {
        return const Left("Email ini sudah digunakan, gunakan email lain");
      }
      return Left("terdapat kesalahan = $e");
    } catch (e) {
      return Left("terdapat kesalahan pada saat catch = $e");
    }
  }
}
