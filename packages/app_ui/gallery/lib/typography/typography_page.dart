import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TypographyPage extends StatelessWidget {
  const TypographyPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const TypographyPage());
  }

  @override
  Widget build(BuildContext context) {
    final textStyleList = [
      _TextItem(name: 'Headline 1', style: AppTextStyle.headline1),
      _TextItem(name: 'Headline 2', style: AppTextStyle.headline2),
      _TextItem(name: 'Headline 3', style: AppTextStyle.headline3),
      _TextItem(name: 'Headline 4', style: AppTextStyle.headline4),
      _TextItem(name: 'Headline 5', style: AppTextStyle.headline5),
      _TextItem(name: 'Headline 6', style: AppTextStyle.headline6),
      _TextItem(name: 'Subtitle 1', style: AppTextStyle.subtitle1),
      _TextItem(name: 'Subtitle 2', style: AppTextStyle.subtitle2),
      _TextItem(name: 'Body Text 1', style: AppTextStyle.bodyText1),
      _TextItem(name: 'Body Text 2', style: AppTextStyle.bodyText2),
      _TextItem(name: 'Button', style: AppTextStyle.button),
      _TextItem(name: 'Caption', style: AppTextStyle.caption),
      _TextItem(name: 'Overline', style: AppTextStyle.overline),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Typography')),
      body: ListView(shrinkWrap: true, children: textStyleList),
    );
  }
}

class _TextItem extends StatelessWidget {
  const _TextItem({
    Key? key,
    required this.name,
    required this.style,
  }) : super(key: key);

  final String name;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.lg,
      ),
      child: Text(name, style: style),
    );
  }
}
