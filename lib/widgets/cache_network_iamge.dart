import 'package:cached_network_image/cached_network_image.dart';

import '../../cmn.dart';

Widget cacheNetworkImg(String? url,
    {double? height,
    double? width,
    double? radius,
    BoxFit fit = BoxFit.fitHeight,
    double borderRadius = 1,
    IconData errorIcon = Icons.error,
    BoxShape shape = BoxShape.rectangle,
    Color borderColor = Colors.white,
    double borderWidth = 0}) {
  if (url == null || url.isEmpty) {
    return SizedBox(width: width, height: height, child: Icon(errorIcon));
  }

  if (radius != null) {
    shape = BoxShape.circle;
    height = width = radius * 2;
  }

  BoxConstraints? bx;
  if (height != null && width != null) bx = BoxConstraints(maxHeight: height, maxWidth: width);

  if (height != null && width == null) bx = BoxConstraints(maxHeight: height);

  if (height == null && width != null) bx = BoxConstraints(maxWidth: width);

  bool isBorder = borderRadius > 0;
  return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              border: !isBorder ? null : Border.all(color: borderColor, width: borderWidth),
              shape: shape,
              borderRadius: shape == BoxShape.circle
                  ? null
                  : !isBorder
                      ? null
                      : BorderRadius.all(Radius.circular(borderRadius)),
              image: DecorationImage(image: imageProvider, fit: fit))),
      placeholder: (context, url) =>
          Container(constraints: bx, child: const Center(child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => Icon(errorIcon));
}
