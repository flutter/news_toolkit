import 'package:flutter/material.dart' hide Spacer;

class ArticleComments extends StatelessWidget {
  const ArticleComments({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline3,
        )
      ],
    );
  }
}
