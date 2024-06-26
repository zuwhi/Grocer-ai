import 'package:appwrite/appwrite.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/constant/appwrite_contant.dart';
import 'package:green_cart_scanner/model/post/posts.dart';
import 'package:green_cart_scanner/service/helper/appwrite_client_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class AppwritePostsRepository {
  late Client _appwriteClient;
  late Databases databases;

  AppwritePostsRepository() {
    _appwriteClient = AppwriteClientHelper.instance.appwriteClient;
    databases = Databases(_appwriteClient);
  }

  getAllPost() async {
    try {
      final getAllpost = await databases.listDocuments(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.collectionPosts,
          queries: [Query.orderDesc("\$createdAt")]);
      List<Posts> listPosts =
          getAllpost.documents.map((e) => Posts.fromMap(e.data)).toList();

      // Logger().d("cek get all post di appwrite post hasilnya dibawh ini ");
      // Logger().d(listPosts);
      return listPosts;
    } catch (e) {
      rethrow;
    }
  }

  Future<Either<String, List<Posts>>> getRecentPosts() async {
    try {
      final getRecentPost = await databases.listDocuments(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.collectionPosts,
          queries: [Query.orderDesc("\$updatedAt"), Query.limit(3)]);

      List<Posts> listOwnPosts =
          getRecentPost.documents.map((e) => Posts.fromMap(e.data)).toList();

      // List<Posts> listOwnPosts = [];

      return Right(listOwnPosts);
    } catch (e) {
      Logger().d(e);
      return Left("terjadi kesalahan : $e");
    }
  }

  Future<Either<String, List<Posts>>> getOwnPosts(
      {required String accountId}) async {
    try {
      final getAccountWhereSameId = await databases.listDocuments(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.collectionPosts,
          queries: [
            Query.equal('accountId', accountId),
            Query.orderDesc("\$updatedAt"),
          ]);

      List<Posts> listOwnPosts = getAccountWhereSameId.documents
          .map((e) => Posts.fromMap(e.data))
          .toList();

      return Right(listOwnPosts);
    } catch (e) {
      Logger().d(e);
      return Left("terjadi kesalahan : $e");
    }
  }

  Future<Either<String, bool>> createPost(Posts post) async {
    dynamic urlProfil;
    dynamic fileId;
    try {
      if (post.image is XFile) {
        final storage = Storage(_appwriteClient);
        final responseImg = await storage.createFile(
          bucketId: Appconstants.postsBucketID,
          fileId: ID.unique(),
          file: InputFile.fromPath(
              path: post.image.path, filename: post.image.name),
        );
        //saya membuat sebuah url agar dapat mengakses ke bucket tersebut hanya dengan url dan url ini saya masukkan ke dalam attribute akun yaitu image
        urlProfil =
            '${Appconstants.endpoint}/storage/buckets/${responseImg.bucketId}/files/${responseImg.$id}/view?project=${Appconstants.projectid}&mode=admin';
        fileId = responseImg.$id;
      }
      final createResult = await databases.createDocument(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.collectionPosts,
          documentId: ID.unique(),
          data: {
            'title': post.title,
            'desc': post.desc,
            'date': post.date,
            'fileId': fileId,
            'image': urlProfil,
            'category': post.category,
            'accountId': post.accountId,
            'author': post.author
          });

      Logger()
          .d('cek hasil pembuatan artikel di service appwrite = $createResult');

      return Right(true);
    } on AppwriteException catch (e) {
      return Left("Terjadi kesalahan : $e");
    } catch (e) {
      return Left("Terjadi kesalahan saat mendapatkan data: $e");
    }
  }

  Future<Either<String, bool>> updatePost(Posts post) async {
    Logger().d('cek id di update appwrite : ${post.id}');

    try {
      dynamic urlPost;
      String? fileId;

      if (post.image != null && post.image is XFile) {
        final storage = Storage(_appwriteClient);
        final responseImg = await storage.createFile(
          bucketId: Appconstants.postsBucketID,
          fileId: ID.unique(),
          file: InputFile.fromPath(
              path: post.image.path, filename: post.image.name),
        );

        urlPost =
            '${Appconstants.endpoint}/storage/buckets/${responseImg.bucketId}/files/${responseImg.$id}/view?project=${Appconstants.projectid}&mode=admin';
        fileId = responseImg.$id;

        Logger().d('cek sebelum hapus file, post fileId : ${post.fileId}');
        if (post.fileId != null) {
          final deleteProfil = await storage.deleteFile(
              bucketId: Appconstants.postsBucketID, fileId: post.fileId!);
          Logger().d('hapus file image');
          Logger().d('hasil hapus : $deleteProfil');
        }
      } else {
        urlPost = post.image;
        fileId = post.fileId;
      }

      final updateResult = await databases.updateDocument(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.collectionPosts,
          documentId: post.id!,
          data: {
            'title': post.title,
            'desc': post.desc,
            'date': post.date,
            'fileId': fileId,
            'image': urlPost,
            'category': post.category,
          });

      Logger().d('checking update post appwrite ${updateResult.data}');
      Logger().d(updateResult.data);

      return Right(true);

    } on AppwriteException catch (e) {
      return Left("Terjadi kesalahan saat mengubah artikel : $e");
    } catch (e) {
      return Left("Terjadi kesalahan saat mengubah artikel: $e");
    }
  }

  deletePost(Posts post) async {
    try {
      final resultDelete = await databases.deleteDocument(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.collectionPosts,
          documentId: post.id!);
    } catch (e) {
      rethrow;
    }
  }
}
