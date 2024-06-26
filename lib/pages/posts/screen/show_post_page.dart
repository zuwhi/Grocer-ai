// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/model/post/posts.dart';
import 'package:green_cart_scanner/pages/navigator/provider/session_provider.dart';
import 'package:green_cart_scanner/pages/navigator/screen/navigator_page.dart';
import 'package:green_cart_scanner/pages/posts/provider/posts_provider/posts_provider.dart';
import 'package:green_cart_scanner/pages/posts/screen/create_post_page.dart';
import 'package:green_cart_scanner/pages/posts/widgets/read_text_form.dart';
import 'package:green_cart_scanner/widgets/custom_snackbar.dart';
import 'package:logger/logger.dart';

class ShowPostPage extends ConsumerStatefulWidget {
  final Posts post;
  const ShowPostPage({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowPostPageState();
}

class _ShowPostPageState extends ConsumerState<ShowPostPage> {
  bool isCanEdit = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SessionState session = ref.watch(sessionNotifierProvider);
      if (session.account!.id == widget.post.accountId) {
        isCanEdit = true;
        Logger().d('is can edit : $isCanEdit');
        setState(() {});
      }
    });
    super.initState();
  }

  void showBottomSheet(data) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
        child: Wrap(
          children: [
            Container(
              height: 15.0,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostPage(
                        posts: widget.post,
                      ),
                    ));
              },
              title: const Text("Edit Article"),
              trailing: const Icon(
                Icons.edit,
                size: 24.0,
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text('Delete article'),
                          content: const Text('yakin mau delete article?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                                child: const Text('Iya'),
                                onPressed: () async {
                                  final result = await ref
                                      .watch(postsNotifierProvider.notifier)
                                      .deletePost(data);

                                  CustomSnackbar.show(
                                    context,
                                    message: result
                                        ? 'Article telah dihapus'
                                        : 'gagal mengahpus article : ${result ?? ''}',
                                    colors: (result) ? Colors.teal : Colors.red,
                                  );
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const NavigatorPage(targetPage: 3),
                                      ),
                                      (route) => false);
                                }),
                          ]);
                    });
              },
              title: const Text("Delete Article"),
              trailing: const Icon(
                Icons.delete,
                size: 24.0,
              ),
            ),
            Container(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Posts post = widget.post;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Article"),
        centerTitle: true,
        actions: [
          isCanEdit
              ? IconButton(
                  onPressed: () {
                    showBottomSheet(post);
                  },
                  icon: const Icon(Icons.menu_rounded))
              : Container(),
          const SizedBox(
            width: 15.0,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: GestureDetector(
                  onTap: () async {
                    final imageProvider =
                        Image.network(post.image.toString()).image;
                    showImageViewer(
                      context,
                      imageProvider,
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: "${post.image ?? ''}",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const LoadingWidgets(),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/empty.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),
              Text(
                post.title ?? "-",
                style: GoogleFonts.inter(
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Authors : ',
                        style: GoogleFonts.inter(
                          height: 1.1,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 13.0,
                        ),
                      ),
                      Text(
                        '${post.author}',
                        style: GoogleFonts.inter(
                          height: 1.1,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${post.date}',
                    style: GoogleFonts.inter(
                      height: 1.1,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              // Text(
              //   textAlign: TextAlign.justify,
              //   '${post.desc}',
              //   style: GoogleFonts.inter(
              //     height: 1.1,
              //     fontWeight: FontWeight.w400,
              //     color: Colors.black87,
              //     fontSize: 15.0,
              //   ),
              // ),

              ReadTextFormQuill(
                text: post.desc ?? '',
              )
            ],
          ),
        ),
      ),
    );
  }
}
