import 'package:appwrite/appwrite.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/constant/appwrite_contant.dart';
import 'package:green_cart_scanner/model/items/dateItems.dart';
import 'package:green_cart_scanner/model/items/item.dart';
import 'package:green_cart_scanner/service/helper/appwrite_client_helper.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class AppwriteItemRepository {
  late Client _appwriteClient;
  late Databases databases;

  AppwriteItemRepository() {
    _appwriteClient = AppwriteClientHelper.instance.appwriteClient;
    databases = Databases(_appwriteClient);
  }

  Future<List<Item>> getData() async {
    try {
      final response = await databases.listDocuments(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.collectionID);
      // Logger().d(response.documents);
      List<Item> listData =
          response.documents.map((e) => Item.fromMap(e.data)).toList();
      return listData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Item>> getItemsDataByDate({required String date}) async {
    try {
      final response = await databases.listDocuments(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.collectionID,
          queries: [
            Query.equal('dateItems', date),
          ]);
      Logger().d(response.documents);
      List<Item> listData =
          response.documents.map((e) => Item.fromMap(e.data)).toList();
      return listData;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String> getDataByDateNow() async {
    try {
      print("proses mencaro data by date now");
      String sekarang = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final responseDateItems = await databases.listDocuments(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.dateItemsID,
          queries: [
            Query.lessThanEqual('date', sekarang),
          ]);


      String result = responseDateItems.documents.last.$id;
      return result;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Either<String, List<DateItems>>> getAllDateItems() async {
    try {
      print("getAllDateItems appwrite ");

      final response = await databases.listDocuments(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.dateItemsID);
      Logger().d(response.documents);

      List<DateItems> result =
          response.documents.map((e) => DateItems.fromMap(e.data)).toList();
      return Right(result);
    } on AppwriteException catch (e) {
      Logger().d(e);
      return Left("terdapat kesalahan : $e");
    } catch (e) {
      return Left("terdapat kesalahan : $e");
    }
  }

  Future<Either<String, String>> createDateItems() async {
    try {
      String sekarang = DateFormat('yyyy-MM-dd').format(DateTime.now());
      // String sekarang = "2024-05-03";
      await databases.createDocument(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.dateItemsID,
          documentId: sekarang,
          data: {"date": sekarang});
      return Right(sekarang);
    } on AppwriteException catch (e) {
      return Left("terdapat kesalahan : $e");
    } catch (e) {
      return Left("terdapat kesalahan : $e");
    }
  }

  Future<Either<String, String>> createItemsAppwrite(
      {required Item item, required String dateItemsId}) async {
    try {
      String id = const Uuid().v4();
      final response = await databases.createDocument(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.collectionID,
          documentId: id,
          data: {
            "nama_item": item.nama_item,
            "nama_kota": item.nama_kota,
            "harga": item.harga,
            "berat": item.berat,
            "dateItems": dateItemsId
          });

      // Logger().d(response.data['nama_item']);
      return Right(response.data['nama_item']);
    } on AppwriteException catch (e) {
      return Left("terdapat kesalahan : $e");
    } catch (e) {
      return Left("terdapat kesalahan : $e");
    }
  }
  Future<Either<String, String>> updateItemsAppwrite(
      {required Item item}) async {
    try {

   await databases.updateDocument(
          databaseId: Appconstants.greenCartDBId,
          collectionId: Appconstants.collectionID,
          documentId: item.id!,
          data: {
            "harga": item.harga,
          });

      return Right(item.nama_item.toString());
    } on AppwriteException catch (e) {
      return Left("terdapat kesalahan saat ubah harga : $e");
    } catch (e) {
      return Left("terdapat kesalahan saat mengubah harga : $e");
    }
  }
}
