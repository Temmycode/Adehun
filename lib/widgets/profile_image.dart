import 'package:adehun_mvp/widgets/custom_network_image.dart';
import 'package:flutter/cupertino.dart';

class ProfileImage extends StatelessWidget {
  final String? image;
  const ProfileImage({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return ClipOval(child: CustomNetworkImage(image: image));
  }
}
