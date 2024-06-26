import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/post/posts.dart';
import 'package:green_cart_scanner/service/appwrite/appwrite_posts.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recent_post_provider.g.dart';

@Riverpod(keepAlive: true)
class RecentPostsNotifier extends _$RecentPostsNotifier {
  @override
  RecentPostsState build() =>
      RecentPostsState(status: StatusCondition.init, message: '', data: []);

  final appwritePost = AppwritePostsRepository();
  getRecentPosts() async {
    print("cek recent provoder");
    state = RecentPostsState(
        status: StatusCondition.loading, message: '', data: []);

    Either<String, List<Posts>> result = await appwritePost.getRecentPosts();

    result.fold(
        (l) => state = RecentPostsState(
            status: StatusCondition.failed, message: 'l', data: []),
        (r) => state = RecentPostsState(
            status: StatusCondition.success, message: '', data: r));
  }
}

class RecentPostsState {
  final StatusCondition status;
  final String message;
  final List<Posts> data;

  RecentPostsState(
      {required this.status, required this.message, required this.data});
}
