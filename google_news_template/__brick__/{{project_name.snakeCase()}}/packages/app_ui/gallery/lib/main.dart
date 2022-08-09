import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:gallery/colors/colors.dart';
import 'package:gallery/spacing/spacing.dart';
import 'package:gallery/typography/typography.dart';
import 'package:gallery/widgets/widgets.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '{{app_name}} Gallery',
      theme: const AppTheme().themeData,
      home: const RootPage(),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      _ListItem(
        icon: const Icon(Icons.color_lens),
        title: const Text('Colors'),
        subtitle: const Text('All of the predefined colors'),
        onTap: () => Navigator.of(context).push<void>(ColorsPage.route()),
      ),
      _ListItem(
        icon: const Icon(Icons.text_format),
        title: const Text('Typography'),
        subtitle: const Text('All of the predefined text styles'),
        onTap: () => Navigator.of(context).push<void>(TypographyPage.route()),
      ),
      _ListItem(
        icon: const Icon(Icons.border_vertical),
        title: const Text('Spacing'),
        subtitle: const Text('All of the predefined spacings'),
        onTap: () => Navigator.of(context).push<void>(SpacingPage.route()),
      ),
      _ListItem(
        icon: const Icon(Icons.widgets),
        title: const Text('Widgets'),
        subtitle: const Text('All of the predefined widgets'),
        onTap: () => Navigator.of(context).push<void>(WidgetsPage.route()),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('{{app_name}} Gallery')),
      body: ListView.separated(
        itemCount: pages.length,
        itemBuilder: (_, index) => pages[index],
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final VoidCallback onTap;
  final Icon icon;
  final Text title;
  final Text subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconTheme(
        data: IconThemeData(
          color: Theme.of(context).iconTheme.color,
        ),
        child: icon,
      ),
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }
}
