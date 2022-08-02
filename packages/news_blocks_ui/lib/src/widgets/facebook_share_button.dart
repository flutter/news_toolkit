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
        size: 24,
        color: Color(0xFF1877F2),
      ),
    );
  }
}
