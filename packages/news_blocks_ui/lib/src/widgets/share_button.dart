import 'package:flutter/material.dart';

/// {@template share_button}
/// A reusable share button.
/// {@endtemplate}
class ShareButton extends StatelessWidget {
  /// {@macro share_button}
  const ShareButton({
    super.key,
    required this.shareText,
    this.onPressed,
  });

  /// The text displayed within share icon.
  final String shareText;

  /// Called when the text field has been tapped.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(
        Icons.share,
        color: Colors.white,
      ),
      onPressed: onPressed,
      label: Text(shareText),
    );
  }
}
