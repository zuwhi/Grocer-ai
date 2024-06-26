import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/post/posts.dart';
import 'package:green_cart_scanner/service/appwrite/appwrite_posts.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'own_post_provider.g.dart';

@Riverpod(keepAlive: true)
class OwnPostsNotifier extends _$OwnPostsNotifier {
  @override
  OwnPostsState build() =>
      OwnPostsState(status: StatusCondition.init, message: '', data: []);
  final appwritePost = AppwritePostsRepository();
  getOwnPosts({required String accountId}) async {
    state =
        OwnPostsState(status: StatusCondition.loading, message: '', data: []);

    Either<String, List<Posts>> result =
        await appwritePost.getOwnPosts(accountId: accountId);

    result.fold(
        (l) => state = OwnPostsState(
            status: StatusCondition.failed, message: 'l', data: []),
        (r) => state = OwnPostsState(
            status: StatusCondition.success, message: '', data: r));
  }
}

class OwnPostsState {
  final StatusCondition status;
  final String message;
  final List<Posts> data;

  OwnPostsState(
      {required this.status, required this.message, required this.data});
}
