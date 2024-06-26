import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/chatbot/neko_model.dart';
import 'package:logger/logger.dart';

class NekoAIService {
  final dio = Dio();
  Future<Either<String, NekoModel>> sendRequest({required String text}) async {
    try {
      String replaceSpace = text.replaceAll(' ', '+');
      final response =
          await dio.get("https://chat.ai.cneko.org/?t=$replaceSpace");

      NekoModel result = NekoModel.fromJson(response.data);
      return Right(result);
    } on DioException catch (e) {
      return Left("terjadi kesalahana : $e");
    } catch (e) {
      return Left("terjadi kesalahana : $e");
    }
  }
}
