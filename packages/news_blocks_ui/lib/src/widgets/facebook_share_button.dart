import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template facebook_share_button}
/// A reusable Facebook share button.
/// {@endtemplate}
class FacebookShareButton extends StatelessWidget {
  /// {@macro facebook_share_button}
  const FacebookShareButton({super.key, this.onTap});

  /// Called when the Icon has been tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.facebook_rounded,
        color: AppColors.blueDress,
      ),
    );
  }
}
