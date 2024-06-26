import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/post/posts.dart';
import 'package:green_cart_scanner/service/appwrite/appwrite_posts.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_provider.g.dart';

@Riverpod(keepAlive: true)
class PostsNotifier extends _$PostsNotifier {
  @override
  PostsState build() =>
      PostsState(status: StatusCondition.init, message: '', data: []);
  final appwritePost = AppwritePostsRepository();

  getAllPost() async {
    state = PostsState(status: StatusCondition.loading, message: '', data: []);
    try {
      final getAllPostResult = await appwritePost.getAllPost();

      state = PostsState(
          status: StatusCondition.success,
          message: 'berhasil mendapatkan data',
          data: getAllPostResult);
    } catch (e) {
      state =
          PostsState(status: StatusCondition.failed, message: '$e', data: []);
    }
  }

  Future<Either<String, bool>> createPost(Posts post) async {
    Logger().d(post);
    state = PostsState(status: StatusCondition.loading, message: '', data: []);
    Either<String, bool> result = await appwritePost.createPost(post);
    return result.fold((l)  =>Left(l)
    , (r) {
      getAllPost();
      return const Right(true);
    });
  }

  Future<Either<String, bool>> updatePost(Posts post) async {
    Either<String, bool> result = await appwritePost.updatePost(post);
    return result.fold((l) => Left(l), (r) {
      getAllPost();
      return const Right(true);
    });
  }

  deletePost(Posts post) async {
    try {
      await appwritePost.deletePost(post);
      await getAllPost();
      return true;
    } catch (e) {
      rethrow;
    }
  }
}

class PostsState {
  final StatusCondition status;
  final String message;
  final List<Posts> data;

  PostsState({required this.status, required this.message, required this.data});
}
