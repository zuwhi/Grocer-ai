import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:camera/camera.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/constant/appwrite_contant.dart';
import 'package:green_cart_scanner/model/account/account_model.dart';
import 'package:green_cart_scanner/model/account/user_detail.dart';
import 'package:green_cart_scanner/model/login/login_params.dart';
import 'package:green_cart_scanner/service/helper/appwrite_client_helper.dart';
import 'package:green_cart_scanner/model/session/session_params.dart';
import 'package:logger/logger.dart';

class AppwriteProfile {
  late Client _appwriteClient;
  late Databases databases;
  late final Account account;

  AppwriteProfile() {
    _appwriteClient = AppwriteClientHelper.instance.appwriteClient;
    databases = Databases(_appwriteClient);
    account = Account(_appwriteClient);
  }

  Future<Either<String, AccountModel>> findAccount(
      {required SessionParams sessionParams}) async {
    try {
      User authCollection = await account.get();
      var response = await databases.listDocuments(
        databaseId: Appconstants.greenCartDBId,
        collectionId: Appconstants.collectionAkun,
        queries: [
          Query.equal('\$id', sessionParams.accountId),
        ],
      );

      UserDetail userCollection =
          UserDetail.fromMap(response.documents.last.data);

      AccountModel accountModel = AccountModel(
        id: authCollection.$id,
        name: authCollection.name,
        email: authCollection.email,
        password: authCollection.password,
        alamat: userCollection.alamat,
        fileId: userCollection.fileId,
        image: userCollection.image,
        role: userCollection.role,
        telepon: userCollection.telepon,
        history: userCollection.history,
      );

      Logger().d(accountModel);

      return Right(accountModel);
    } on AppwriteException catch (e) {
      return Left("terdapat kesalahan = $e");
    } catch (e) {
      return Left("terdapat kesalahan pada saat catch = $e");
    }
  }

  Future<Either<String, bool>> logout({required String sessionId}) async {
    try {
      String authCollection = await account.deleteSessions();
      // String authCollection = await account.deleteSession(sessionId: sessionId);
      return const Right(true);
    } on AppwriteException catch (e) {
      return Left("terdapat kesalahan = $e");
    } catch (e) {
      return Left("terdapat kesalahan pada saat catch = $e");
    }
  }

  Future<Either<String, bool>> updateProfilAccount(AccountModel akun) async {
    try {
      dynamic urlProfil = akun.image;
      dynamic fileId = akun.fileId;

      if (akun.image is XFile) {
        Logger().d("cek akun memiliki gambar : ${akun.image.name}");
        final storage = Storage(_appwriteClient);
        final responseImg = await storage.createFile(
          bucketId: Appconstants.profilBucketID,
          fileId: ID.unique(),
          file: InputFile.fromPath(
              path: akun.image.path, filename: akun.image.name),
        );

        urlProfil =
            '${Appconstants.endpoint}/storage/buckets/${responseImg.bucketId}/files/${responseImg.$id}/view?project=${Appconstants.projectid}&mode=admin';
        fileId = responseImg.$id;
        Logger().d('cek sebelum hapus file, akun fileId : ${akun.fileId}');
        if (akun.fileId != null) {
          final deleteProfil = await storage.deleteFile(
              bucketId: Appconstants.profilBucketID, fileId: akun.fileId!);
          Logger().d('hapus file image');
          Logger().d('hasil hapus : $deleteProfil');
        }
      }
      Logger().d('mulai ');
      Logger().d(akun);
      await account.updateName(name: akun.name!);

      Logger().d('setengah ');
      await databases.updateDocument(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.collectionAkun,
          documentId: akun.id!,
          data: {
            'alamat': akun.alamat,
            'telepon': akun.telepon,
            'image': urlProfil,
            'fileId': fileId
          });
      Logger().d('oke');
      return const Right(true);
    } on AppwriteException catch (e) {
      Logger().d(e);
      return Left("terdapat kesalahan = $e");
    } catch (e) {
      return Left("terdapat kesalahan pada saat catch = $e");
    }
  }

  Future<Either<String, bool>> updateEmailAndPasswordAccount(
      {required LoginParams loginParams}) async {
    try {
      print("pengecekan di update email n password");
      Logger().d(loginParams.email);
      Logger().d(loginParams.password);
      Logger().d(loginParams);
      if (loginParams.newPassword!.isEmpty) {
        print("update email ");
        final response = await account.updateEmail(
            email: loginParams.email, password: loginParams.password);
        Logger().d(response.email);

        return const Right(true);
      }
      {
        await account.updatePassword(
            password: loginParams.newPassword ?? '',
            oldPassword: loginParams.password);
      }

      return const Right(true);
    } on AppwriteException catch (e) {
      Logger().d("Cek kesalahan saat update email n password : $e");
      Logger().d(e.code);
      if (e.code == 409) {
        return const Right(true);
      } else if (e.code == 401) {
        return const Left("Password yang anda masukkan salah");
      } else if (e.code == 400) {
        return const Left("Masukkan Password yang benar");
      }
      return Left("terdapat kesalahan = $e");
    } catch (e) {
      return Left("terdapat kesalahan pada saat catch = $e");
    }
  }
}
