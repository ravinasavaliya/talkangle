import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/const/app_assets.dart';

class AppShowProfilePic extends StatelessWidget {
  final VoidCallback onTap;
  final Color? color;
  final double? radius;
  final bool? borderShow;
  final String image;

  const AppShowProfilePic({
    super.key,
    required this.onTap,
    this.color,
    this.radius,
    this.borderShow = true,
    this.image = '',
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    // final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: radius ?? h * 0.07,
        width: radius ?? h * 0.07,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: borderShow == true
              ? Border.all(
                  color: color ?? whiteColor,
                  width: 0.5,
                )
              : Border.all(color: Colors.transparent),
        ),
        child: Padding(
          padding: EdgeInsets.all(radius != null ? radius! / 16 : 3),
          child: Container(
            height: radius ?? h * 0.07, // 80
            width: radius ?? h * 0.07, // 80
            decoration: const BoxDecoration(color: containerColor, shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius ?? 200),
              child: image == "" || image == "0"
                  ? assetImage(AppAssets.blankProfile)
                  : CachedNetworkImage(
                      imageUrl: image,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      placeholder: (context, url) => assetImage(AppAssets.blankProfile, fit: BoxFit.cover),
                      errorWidget: (context, url, error) => assetImage(AppAssets.blankProfile, fit: BoxFit.cover),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
