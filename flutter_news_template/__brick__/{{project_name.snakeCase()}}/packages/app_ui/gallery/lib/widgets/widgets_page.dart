import 'package:flutter/material.dart';
import 'package:gallery/widgets/widgets.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const WidgetsPage());
  }

  @override
  Widget build(BuildContext context) {
    final widgets = <_ListItem>[
      _ListItem(
        icon: const Icon(Icons.input),
        title: const Text('Logo'),
        onTap: () => Navigator.of(context).push<void>(AppLogoPage.route()),
      ),
      _ListItem(
        icon: const Icon(Icons.vignette),
        title: const Text('App Buttons'),
        onTap: () => Navigator.of(context).push<void>(AppButtonPage.route()),
      ),
      _ListItem(
        icon: const Icon(Icons.ad_units_rounded),
        title: const Text('Show Modal'),
        onTap: () => Navigator.of(context).push<void>(ShowAppModalPage.route()),
      ),
      _ListItem(
        icon: const Icon(Icons.email_outlined),
        title: const Text('Text Fields'),
        onTap: () => Navigator.of(context).push<void>(AppTextFieldPage.route()),
      ),
      _ListItem(
        icon: const Icon(Icons.arrow_back_ios),
        title: const Text('App Back Button'),
        onTap: () =>
            Navigator.of(context).push<void>(AppBackButtonPage.route()),
      ),
      _ListItem(
        icon: const Icon(Icons.switch_left),
        title: const Text('App Switch'),
        onTap: () => Navigator.of(context).push<void>(AppSwitchPage.route()),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Widgets')),
      body: ListView.separated(
        itemCount: widgets.length,
        itemBuilder: (_, index) => widgets[index],
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({required this.icon, required this.title, this.onTap});

  final VoidCallback? onTap;
  final Widget icon;
  final Text title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: title,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
