import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';

class CustomImageCacheNetwork extends StatelessWidget {
  const CustomImageCacheNetwork({
    super.key,
    required this.url,
  });

  final dynamic url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "${url ?? ''}",
      fit: BoxFit.cover,
      placeholder: (context, url) => const LoadingWidgets(),
      errorWidget: (context, url, error) =>
          Image.asset('assets/images/profil.jpg'),
    );
  }
}
