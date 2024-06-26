import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/model/post/posts.dart';
import 'package:green_cart_scanner/pages/posts/screen/show_post_page.dart';
import 'package:green_cart_scanner/pages/posts/widgets/read_text_for_card.dart';

class CardPost extends StatelessWidget {
  final Posts post;
  final List<String> category;
  const CardPost({super.key, required this.post, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowPostPage(
                post: post,
              ),
            ));
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 0.5),
                blurRadius: 0.5,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            post.title.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              height: 1.2,
                              color: AppColor.grey1,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Stack(
                          children: [
                            SizedBox(
                                width: 300,
                                child: ReadTextFormQuillForCard(
                                  text: post.desc.toString(),
                                )),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowPostPage(
                                        post: post,
                                      ),
                                    ));
                              },
                              child: Container(
                                height: 38,
                                color: Colors.transparent,
                                width: double.infinity,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                'Categori :  ',
                                style: GoogleFonts.roboto(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              width: 160,
                              child: ListView.builder(
                                itemCount: category.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.greenAccent,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 2)),
                                            onPressed: () {},
                                            child: Text(
                                              category[index],
                                              style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 8,
                                              ),
                                            )),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    height: 100,
                    width: 100,
                    child: post.image != null
                        ? CachedNetworkImage(
                            imageUrl: "${post.image}",
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const LoadingWidgets(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Image.asset(
                            'assets/images/empty.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
