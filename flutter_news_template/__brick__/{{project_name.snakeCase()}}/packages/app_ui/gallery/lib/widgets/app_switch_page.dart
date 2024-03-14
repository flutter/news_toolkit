// ignore_for_file: avoid_field_initializers_in_const_classes

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppSwitchPage extends StatelessWidget {
  AppSwitchPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => AppSwitchPage());
  }

  final appSwitchList = [
    const _AppSwitch(switchType: SwitchType.on),
    const _AppSwitch(switchType: SwitchType.off),
    const _AppSwitch(switchType: SwitchType.noLabelOn),
    const _AppSwitch(switchType: SwitchType.noLabelOff),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Switches')),
      body: ListView(children: appSwitchList),
    );
  }
}

enum SwitchType {
  on,
  off,
  noLabelOn,
  noLabelOff,
}

class _AppSwitch extends StatelessWidget {
  const _AppSwitch({required this.switchType});

  AppSwitch get appSwitch {
    switch (switchType) {
      case SwitchType.on:
        return AppSwitch(
          onChanged: (_) {},
          onText: 'On',
          value: true,
        );
      case SwitchType.off:
        return AppSwitch(
          onChanged: (_) {},
          onText: 'Off',
          value: false,
        );

      case SwitchType.noLabelOn:
        return AppSwitch(
          onChanged: (_) {},
          value: true,
        );
      case SwitchType.noLabelOff:
        return AppSwitch(
          onChanged: (_) {},
          value: false,
        );
    }
  }

  final SwitchType switchType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: appSwitch,
    );
  }
}
