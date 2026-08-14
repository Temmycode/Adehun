import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final BoxFit? fit;

  const CustomNetworkImage({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image ?? '',
      fit: fit ?? BoxFit.cover,
      height: height,
      width: width,
      filterQuality: FilterQuality.medium,
      placeholder: (context, url) {
        return Image.asset(
          placeholder,
          height: height,
          width: width,
          fit: BoxFit.cover,
        );
      },
      errorWidget: (c, o, s) {
        return Image.asset(
          placeholder,
          height: height,
          width: width,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
