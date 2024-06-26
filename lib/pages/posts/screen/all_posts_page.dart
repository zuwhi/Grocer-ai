import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/model/post/posts.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:green_cart_scanner/pages/posts/provider/posts_provider/posts_provider.dart';
import 'package:green_cart_scanner/pages/posts/screen/create_post_page.dart';
import 'package:green_cart_scanner/pages/posts/widgets/card_post_widgets.dart';

class AllPostsPage extends ConsumerStatefulWidget {
  const AllPostsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllPostsPageState();
}

class _AllPostsPageState extends ConsumerState<AllPostsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PostsState state = ref.watch(postsNotifierProvider);
      if (state.status == StatusCondition.success) {
        null;
      } else {
        ref.watch(postsNotifierProvider.notifier).getAllPost();
      }
    });
    super.initState();
  }

  Future<void> _handleRefresh() async {
    await ref.watch(postsNotifierProvider.notifier).getAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Semua Artikel"),
        centerTitle: true,
        actions: const [],
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        child: Consumer(
          builder: (context, ref, child) {
            PostsState state = ref.watch(postsNotifierProvider);
            if (state.status == StatusCondition.loading) {
              return const LoadingWidgets();
            }

            if (state.status == StatusCondition.success) {
              List<Posts> posts = state.data;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    margin: const EdgeInsets.only(bottom: 100, top: 2),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: posts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Posts post = posts[index];
                        List<String> category = post.category!.split(',');

                        return CardPost(post: post, category: category);
                      },
                    )),
              );
            }

            if (state.status == StatusCondition.failed) {
              return Center(
                child: Text("gagal mendapatkan data = ${state.message}"),
              );
            }

            return Container();
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: AppColor.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PostPage(),
                ));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
