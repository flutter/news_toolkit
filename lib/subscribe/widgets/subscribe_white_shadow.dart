import 'package:flutter/material.dart';

@visibleForTesting
class SubscribeWhiteShadow extends StatelessWidget {
  const SubscribeWhiteShadow({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.75),
                  Colors.white.withOpacity(0.98),
                  Colors.white.withOpacity(1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          child
        ],
      ),
    );
  }
}
