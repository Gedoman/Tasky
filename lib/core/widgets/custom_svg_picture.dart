import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvgPicture extends StatelessWidget {
  final String path;
  final bool withColorFilter;
  final double? height;
  final double? width;

  const CustomSvgPicture({
    super.key,
    required this.path,
    this.withColorFilter = true,
    this.height,
    this.width,
  });

  const CustomSvgPicture.withoutColor({
    super.key,
    required this.path,
     this.height,
     this.width,
  }) : withColorFilter = false;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      height: height,
      width: width,
      colorFilter: withColorFilter
          ? ColorFilter.mode(
              Theme.of(context).colorScheme.secondaryContainer,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
