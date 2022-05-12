import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

/// {@template overlaid_image}
/// Image widget overlaid with colored gradient.
/// {@endtemplate}
class OverlaidImage extends StatelessWidget {
  /// {@macro overlaid_image}
  const OverlaidImage({
    Key? key,
    required this.imageUrl,
    required this.gradientColor,
  }) : super(key: key);

  /// Url of displayed image.
  final String imageUrl;

  /// The color of gradient.
  final Color gradientColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: const Key('overlaidImage_stack'),
      children: [
        Image.network(
          imageUrl,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.transparent,
                gradientColor.withOpacity(0.7),
              ],
            ),
          ),
          child: const SizedBox.expand(),
        ),
      ],
    );
  }
}
