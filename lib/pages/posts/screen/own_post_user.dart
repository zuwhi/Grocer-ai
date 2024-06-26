import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/model/post/posts.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:green_cart_scanner/pages/navigator/provider/session_provider.dart';
import 'package:green_cart_scanner/pages/posts/provider/own_post/own_post_provider.dart';
import 'package:green_cart_scanner/pages/posts/widgets/card_post_widgets.dart';
import 'package:green_cart_scanner/widgets/not_found_widgets.dart';

class OwnPostUserPage extends ConsumerStatefulWidget {
  const OwnPostUserPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OwnPostUserPageState();
}

class _OwnPostUserPageState extends ConsumerState<OwnPostUserPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SessionState state = ref.watch(sessionNotifierProvider);
      ref
          .watch(ownPostsNotifierProvider.notifier)
          .getOwnPosts(accountId: state.account!.id ?? "");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artikel Anda"),
        centerTitle: true,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Consumer(
          builder: (context, wiRef, child) {
            OwnPostsState state = wiRef.watch(ownPostsNotifierProvider);
            if (state.status == StatusCondition.loading) {
              return const Padding(
                padding: EdgeInsets.only(top: 300),
                child: LoadingWidgets(),
              );
            }

            if (state.status == StatusCondition.success) {
              List<Posts> posts = state.data;

              if (posts.isEmpty) {
                return const Center(
                  child: NotFoundWidgets(
                    height: 200,
                  ),
                );
              }
              return SingleChildScrollView(
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
    );
  }
}
